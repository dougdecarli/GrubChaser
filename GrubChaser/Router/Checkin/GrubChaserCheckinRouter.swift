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
    
    func goToCheckinTabBar(restaurant: GrubChaserRestaurantModel,
                           tableId: String) {
        let tabBar = storyboard.instantiateViewController(withIdentifier: "checkinTabBar") as! GrubChaserCheckinTabBarController
        tabBar.restaurant = restaurant
        tabBar.tableId = tableId
        navigationController.pushViewController(tabBar, animated: true)
    }
}
