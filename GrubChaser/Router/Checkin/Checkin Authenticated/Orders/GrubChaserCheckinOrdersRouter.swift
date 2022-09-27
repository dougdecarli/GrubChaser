//
//  GrubChaserCheckinOrdersRouter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 26/09/22.
//

import UIKit

class GrubChaserCheckinOrdersRouter: GrubChaserCheckinOrdersRouterProtocol {
    private let navigationController: UINavigationController,
                storyboard = UIStoryboard(name: "Checkin", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
