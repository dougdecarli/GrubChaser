//
//  GrubChaserCheckinMenuRouter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 24/09/22.
//

import UIKit

class GrubChaserCheckinMenuRouter: GrubChaserCheckinMenuRouterProtocol {
    private let navigationController: UINavigationController,
                storyboard = UIStoryboard(name: "Checkin", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentProductModal(product: GrubChaserProduct) {
        let vc = storyboard.instantiateViewController(withIdentifier: "productModalVC") as! GrubChaserProductModalViewController
        vc.viewModel = GrubChaserProductModalViewModel(router: self,
                                                       product: product)
        navigationController.present(vc, animated: true)
    }
    
    func presentBagOrderModal(products: [GrubChaserProduct],
                              restaurant: GrubChaserRestaurantModel,
                              table: GrubChaserTableModel) {
        let vc = storyboard.instantiateViewController(withIdentifier: "orderBagVC") as! GrubChaserOrderBagViewController
        vc.viewModel = GrubChaserOrderBagViewModel(router: self,
                                                   products: products,
                                                   restaurant: restaurant,
                                                   table: table,
                                                   viewControllerRef: vc)
        navigationController.present(vc, animated: true)
    }
}
