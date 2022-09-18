//
//  GrubChaserCheckinRouterProtocol.swift
//  GrubChaser
//
//  Created by Douglas Immig on 13/09/22.
//

import Foundation

protocol GrubChaserCheckinRouterProtocol {
    func goToRestaurantOrder(restaurant: GrubChaserRestaurantModel)
    func presentProductModal(product: GrubChaserProduct)
}
