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
                         code: String) -> Observable<GrubChaserTableModel>
    func postTableCheckin(restaurantId: String,
                          tableId: String,
                          userModel: GrubChaserUserModel) -> Observable<Void>
    func postOrder(restaurantId: String,
                   tableId: String,
                   order: GrubChaserOrderModel) -> Observable<Void>
    func listenOrderStatusChanged(restaurantId: String) -> Observable<Void>
    func putOrderIdIntoDocument(orderRef: DocumentReference) -> Observable<Void>
    func getUserOrdersInTable(restaurantId: String,
                              tableId: String,
                              userId: String) -> Observable<[GrubChaserOrderModel]>
    func getRestaurantCategory(categoryRef: DocumentReference) -> Observable<GrubChaserRestaurantCategory>
    func getTables(from restaurantId: String) -> Observable<[GrubChaserTableModel]>
    func isUserChechedIn(restaurantId: String,
                         userModel: GrubChaserUserModel) -> Observable<GrubChaserTableModel>
    func listenToClientCheckout(restaurantId: String,
                                tableId: String,
                                userId: String) -> Observable<GrubChaserTableModel>
    func createUser(userModel: GrubChaserUserModel) -> Observable<DocumentReference>
    func checkUserHasAccount(uid: String) -> Observable<Bool>
}
