//
//  GrubChaserHomeRouter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/08/22.
//

import Foundation
import UIKit

class GrubChaserHomeRouter: GrubChaserHomeRouterProtocol {
    private let navigationController: UINavigationController,
                storyboard = UIStoryboard(name: "Inicio", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToRestaurantList(restaurants: [GrubChaserRestaurantModel]) {
        let vc = storyboard.instantiateViewController(withIdentifier: "restaurantsListVC") as! GrubChaserRestaurantListViewController
        vc.viewModel = GrubChaserRestaurantListViewModel(router: self,
                                                         restaurants: restaurants)
        navigationController.pushViewController(vc,
                                                animated: true)
    }
    
    func goToRestaurantDetails(restaurant: GrubChaserRestaurantModel) {
        let vc = storyboard.instantiateViewController(withIdentifier: "restaurantDetailsVC") as! GrubChaserRestaurantDetailsViewController
        vc.viewModel = GrubChaserRestaurantDetailsViewModel(router: self,
                                                            restaurant: restaurant)
        navigationController.pushViewController(vc,
                                                animated: true)
    }
    
    func presentRestaurantDetailsFromMap(restaurant: GrubChaserRestaurantModel) {
        let vc = storyboard.instantiateViewController(withIdentifier: "restaurantDetailsVC") as! GrubChaserRestaurantDetailsViewController
        vc.viewModel = GrubChaserRestaurantDetailsViewModel(router: self,
                                                            restaurant: restaurant)
        navigationController.present(vc, animated: true)
    }
}
