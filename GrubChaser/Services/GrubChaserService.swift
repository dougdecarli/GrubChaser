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
}

//MARK: Login
