//
//  GrubChaserCheckinTabBarController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 24/09/22.
//

import UIKit

final class GrubChaserCheckinTabBarController: UITabBarController {
    var restaurant: GrubChaserRestaurantModel!,
        table: GrubChaserTableModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataInjectionToViewControllers()
    }

    private func setupDataInjectionToViewControllers() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if let navBar = viewController as? UINavigationController {
                if let orderVC = navBar.topViewController as? GrubChaserRestaurantOrderViewController {
                    loadOrderVC(orderVC)
                } else {
                    if let ordersVC = navBar.topViewController as? GrubChaserOrdersViewController {
                        loadOrdersVC(ordersVC)
                    }
                }
            }
        }
    }
    
    private func loadOrderVC(_ orderVC: GrubChaserRestaurantOrderViewController) {
        let router = GrubChaserCheckinMenuRouter(navigationController: orderVC.navigationController ?? UINavigationController())
        let viewModel = GrubChaserRestaurantOrderViewModel(router: router,
                                                           restaurant: restaurant,
                                                           table: table)
        orderVC.viewModel = viewModel
    }
    
    private func loadOrdersVC(_ ordersVC: GrubChaserOrdersViewController) {
        let router = GrubChaserCheckinOrdersRouter(navigationController: ordersVC.navigationController ?? UINavigationController())
        let viewModel = GrubChaserOrdersViewModel(router: router,
                                                  restaurant: restaurant,
                                                  table: table,
                                                  viewControllerRef: ordersVC)
        ordersVC.viewModel = viewModel
    }
}
