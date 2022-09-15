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
    func checkinFromCode(restaurantId: String,
                         code: String) -> Observable<String?>
    func postTableCheckin(restaurantId: String,
                          tableId: String) -> Observable<Void>
    func getRestaurantCategory(categoryRef: DocumentReference) -> Observable<GrubChaserRestaurantCategory>
    func createUser(userModel: GrubChaserUserModel) -> Observable<DocumentReference>
    func checkUserHasAccount(uid: String) -> Observable<Bool>
}
