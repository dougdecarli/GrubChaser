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
}
