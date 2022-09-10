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
    
    let dbFirestore: Firestore,
        disposeBag = DisposeBag()
    
    init(dbFirestore: Firestore) {
        self.dbFirestore = dbFirestore
    }
    
    func getRestaurants() -> Observable<[GrubChaserRestaurantModel]> {
        dbFirestore
            .collection("restaurants")
            .rx
            .getDocuments()
            .decode(GrubChaserRestaurantModel.self)  
    }
    
    func getRestaurantCategory(categoryRef: DocumentReference) -> Observable<GrubChaserRestaurantCategory> {
        categoryRef
            .rx
            .getDocument()
            .decodeDocument(GrubChaserRestaurantCategory.self)
    }
    
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
