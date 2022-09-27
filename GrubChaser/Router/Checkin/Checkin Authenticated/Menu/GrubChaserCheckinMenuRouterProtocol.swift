//
//  GrubChaserCheckinMenuRouterProtocol.swift
//  GrubChaser
//
//  Created by Douglas Immig on 24/09/22.
//

import Foundation

protocol GrubChaserCheckinMenuRouterProtocol {
    func presentProductModal(product: GrubChaserProduct)
    func presentBagOrderModal(products: [GrubChaserProduct],
                              restaurant: GrubChaserRestaurantModel,
                              tableId: String)
}
