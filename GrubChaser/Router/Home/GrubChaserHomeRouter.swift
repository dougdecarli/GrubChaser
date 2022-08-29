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
                service: GrubChaserServiceProtocol,
                storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    init(navigationController: UINavigationController,
         service: GrubChaserServiceProtocol) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func goToRestaurantList(restaurants: [GrubChaserRestaurantModel]) {
        let vc = storyboard.instantiateViewController(withIdentifier: "restaurantsListVC") as! GrubChaserRestaurantListViewController
        vc.viewModel = GrubChaserRestaurantListViewModel(service: service,
                                                         router: self,
                                                         restaurants: restaurants)
        navigationController.pushViewController(vc,
                                                animated: true)
    }
}
