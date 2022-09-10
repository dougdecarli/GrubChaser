//
//  GrubChaserLoginRouter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 07/09/22.
//

import UIKit

class GrubChaserLoginRouter: GrubChaserLoginRouterProtocol {
    private let service: GrubChaserServiceProtocol,
                window: UIWindow?,
                loginStoryboard = UIStoryboard(name: "Login",
                                          bundle: nil),
                mainStoryboard = UIStoryboard(name: "Main",
                      bundle: nil)
    
    private var navigationController: UINavigationController!
    
    init(window: UIWindow?,
         service: GrubChaserServiceProtocol) {
        self.window = window
        self.service = service
    }
    
    func start() {
        goToLogin()
    }
    
    func goToMainFlow() {
        let tabBar = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBar")
        window?.rootViewController = tabBar
    }
    
    func goToLogin() {
        let vc = loginStoryboard.instantiateViewController(withIdentifier: "loginVC") as! GrubChaserLoginViewController
        vc.viewModel = GrubChaserLoginViewModel(service: service,
                                                router: self,
                                                viewControllerRef: vc)
        setupNavigationController(vc)
        window?.rootViewController = navigationController
    }
    
    private func setupNavigationController(_ vc: UIViewController) {
        navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = ColorPallete.defaultRed
    }
}
