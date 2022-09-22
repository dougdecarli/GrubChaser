//
//  GrubChaserService.swift
//  GrubChaser
//
//  Created by Douglas Immig on 16/08/22.
//

import FirebaseFirestore
import RxSwift
import RxCocoa
import RxFirebase
import FirebaseAuth

class GrubChaserService: GrubChaserServiceProtocol {
    private let dbFirestore: Firestore,
                disposeBag = DisposeBag()
    
    static var instance: GrubChaserService = {
        return GrubChaserService()
    }()
    
    var restaurants: [GrubChaserRestaurantModel]? = nil
    
    private init(dbFirestore: Firestore = Firestore.firestore()) {
        self.dbFirestore = dbFirestore
    }
    
    func getRestaurants() -> Observable<[GrubChaserRestaurantModel]> {
        dbFirestore
            .collection("restaurants")
            .rx
            .getDocuments()
            .decode(GrubChaserRestaurantModel.self)  
    }
    
    func checkinFromCode(restaurantId: String,
                         code: String) -> Observable<String?> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .whereField("code", isEqualTo: code)
            .rx
            .getDocuments()
            .map(\.documents.first?.documentID)
    }
    
    func postTableCheckin(restaurantId: String,
                          tableId: String) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .document(tableId)
            .rx
            .updateData(["isOccupied" : true])
    }
    
    func postOrder(restaurantId: String,
                   tableId: String,
                   order: GrubChaserOrderModel) -> Observable<DocumentReference> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .document(tableId)
            .collection("orders")
            .rx
            .addDocument(data: order.toDictionary!)
    }
    
    func getRestaurantCategory(categoryRef: DocumentReference) -> Observable<GrubChaserRestaurantCategory> {
        categoryRef
            .rx
            .getDocument()
            .decodeDocument(GrubChaserRestaurantCategory.self)
    }
    
    //MARK: - Sign in & Sign up
    func createUser(userModel: GrubChaserUserModel) -> Observable<DocumentReference> {
        dbFirestore
            .collection("users")
            .rx
            .addDocument(data: userModel.toDictionary!)
    }
    
    func checkUserHasAccount(uid: String) -> Observable<Bool> {
        dbFirestore.collection("users")
            .whereField("uid", isEqualTo: uid)
            .rx
            .getDocuments()
            .map { !$0.isEmpty }
    }
}
