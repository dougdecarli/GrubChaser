//
//  GrubChaserCheckinRouter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 13/09/22.
//

import UIKit

class GrubChaserCheckinRouter: GrubChaserCheckinRouterProtocol {
    private let navigationController: UINavigationController,
                storyboard = UIStoryboard(name: "Checkin", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToRestaurantOrder(restaurant: GrubChaserRestaurantModel,
                             tableId: String) {
        let vc = storyboard.instantiateViewController(withIdentifier: "restaurantOrderVC") as! GrubChaserRestaurantOrderViewController
        vc.viewModel = GrubChaserRestaurantOrderViewModel(router: self,
                                                          restaurant: restaurant,
                                                          tableId: tableId)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentProductModal(product: GrubChaserProduct) {
        let vc = storyboard.instantiateViewController(withIdentifier: "productModalVC") as! GrubChaserProductModalViewController
        vc.viewModel = GrubChaserProductModalViewModel(router: self,
                                                       product: product)
        navigationController.present(vc, animated: true)
    }
    
    func presentBagOrderModal(products: [GrubChaserProduct],
                              restaurant: GrubChaserRestaurantModel,
                              tableId: String) {
        let vc = storyboard.instantiateViewController(withIdentifier: "orderBagVC") as! GrubChaserOrderBagViewController
        vc.viewModel = GrubChaserOrderBagViewModel(router: self,
                                                   products: products,
                                                   restaurant: restaurant,
                                                   tableId: tableId,
                                                   viewControllerRef: vc)
        navigationController.present(vc, animated: true)
    }
}
