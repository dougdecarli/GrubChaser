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
                         code: String) -> Observable<GrubChaserTableModel> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .whereField("code", isEqualTo: code)
            .rx
            .getFirstDocument()
            .decodeDocument(GrubChaserTableModel.self)
    }
    
    func postTableCheckin(restaurantId: String,
                          tableId: String,
                          userModel: GrubChaserUserModel) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .document(tableId)
            .rx
            .updateData(["clients": FieldValue.arrayUnion([userModel.toDictionary!])])
            .map { _ in }
    }
    
    func postOrder(restaurantId: String,
                   tableId: String,
                   order: GrubChaserOrderModel) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("orders")
            .rx
            .addDocument(data: order.toDictionary!)
            .map { docRef in
                docRef
                    .rx
                    .setData(["orderId": docRef.documentID], merge: true)
            }
            .map { _ in }
    }
    
    func putOrderIdIntoDocument(orderRef: DocumentReference) -> Observable<Void> {
        orderRef
            .rx
            .setData(["orderId": orderRef.documentID], merge: true)
    }
    
    func getUserOrdersInTable(restaurantId: String,
                              tableId: String,
                              userId: String) -> Observable<[GrubChaserOrderModel]> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("orders")
            .whereField("userId", isEqualTo: userId)
            .whereField("tableId", isEqualTo: tableId)
            .order(by: "timestamp", descending: true)
            .rx
            .getDocuments()
            .decode(GrubChaserOrderModel.self)
    }
    
    func listenOrderStatusChanged(restaurantId: String) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("orders")
            .rx
            .listen(includeMetadataChanges: true)
            .map { _ in }
    }
    
    func getRestaurantCategory(categoryRef: DocumentReference) -> Observable<GrubChaserRestaurantCategory> {
        categoryRef
            .rx
            .getDocument()
            .decodeDocument(GrubChaserRestaurantCategory.self)
    }
    
    func getTables(from restaurantId: String) -> Observable<[GrubChaserTableModel]> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .rx
            .getDocuments()
            .decode(GrubChaserTableModel.self)
    }
    
    func isUserChechedIn(restaurantId: String,
                         userModel: GrubChaserUserModel) -> Observable<GrubChaserTableModel> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .whereField("clients", arrayContainsAny: [userModel.toDictionary!])
            .rx
            .getFirstDocument()
            .decodeDocument(GrubChaserTableModel.self)
    }
    
    func listenToClientCheckout(restaurantId: String,
                                tableId: String,
                                userId: String) -> Observable<GrubChaserTableModel> {
        dbFirestore
            .collection("restaurants")
            .document(restaurantId)
            .collection("tables")
            .document(tableId)
            .rx
            .listen(includeMetadataChanges: true)
            .decodeDocument(GrubChaserTableModel.self)
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
