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
                service: GrubChaserServiceProtocol
    
    init(navigationController: UINavigationController,
         service: GrubChaserServiceProtocol) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        
    }
    
    func push(_ vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
}
