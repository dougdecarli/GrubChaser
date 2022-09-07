//
//  GrubChaserServiceProtocol.swift
//  GrubChaser
//
//  Created by Douglas Immig on 17/08/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol GrubChaserServiceProtocol {
    func getRestaurants() -> Observable<[GrubChaserRestaurantModel]>
    func getRestaurantCategory(categoryRef: DocumentReference) -> Observable<GrubChaserRestaurantCategory>
}
