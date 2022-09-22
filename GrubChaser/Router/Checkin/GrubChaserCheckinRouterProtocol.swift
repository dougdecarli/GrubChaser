//
//  GrubChaserCheckinRouterProtocol.swift
//  GrubChaser
//
//  Created by Douglas Immig on 13/09/22.
//

import Foundation

protocol GrubChaserCheckinRouterProtocol {
    func goToRestaurantOrder(restaurant: GrubChaserRestaurantModel,
                             tableId: String)
    func presentProductModal(product: GrubChaserProduct)
    func presentBagOrderModal(products: [GrubChaserProduct],
                              restaurant: GrubChaserRestaurantModel,
                              tableId: String)
}
