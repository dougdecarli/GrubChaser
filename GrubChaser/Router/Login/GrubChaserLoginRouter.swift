//
//  GrubChaserLoginRouter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 07/09/22.
//

import UIKit

class GrubChaserLoginRouter: GrubChaserLoginRouterProtocol {
    private let window: UIWindow?,
                loginStoryboard = UIStoryboard(name: "Login",
                                          bundle: nil),
                mainStoryboard = UIStoryboard(name: "Main",
                      bundle: nil)
    
    private var navigationController: UINavigationController!
    
    init(window: UIWindow?) {
        self.window = window
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
        vc.viewModel = GrubChaserLoginViewModel(router: self,
                                                viewControllerRef: vc)
        setupNavigationController(vc)
        window?.rootViewController = navigationController
    }
    
    func goToSignUp() {
        let vc = loginStoryboard.instantiateViewController(withIdentifier: "signUpVC") as! GrubChaserSignUpViewController
        vc.viewModel = GrubChaserSignUpViewModel(router: self,
                                                 viewControllerRef: vc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func setupNavigationController(_ vc: UIViewController) {
        navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = ColorPallete.defaultRed
    }
}
