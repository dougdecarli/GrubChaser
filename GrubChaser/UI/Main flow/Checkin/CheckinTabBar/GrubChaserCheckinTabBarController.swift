//
//  GrubChaserCheckinTabBarController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 24/09/22.
//

import FirebaseFirestore
import RxSwift
import RxCocoa
import RxFirebase
import FirebaseAuth
import UIKit

final class GrubChaserCheckinTabBarController: UITabBarController {
    var restaurant: GrubChaserRestaurantModel!,
        table: GrubChaserTableModel!,
        disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataInjectionToViewControllers()
    }
    
    //MARK: - Checkout listener
    func observeClientIsCheckedOut() {
        func handleSuccess(table: GrubChaserTableModel) {
            if !(table.clients!.contains(where: { $0.uid == UserDefaults.standard.getLoggedUser()!.uid })) {
                showAlert(with: .init(title: "Sua comanda foi fechada!", message: "", viewControllerRef: self))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        GrubChaserService.instance.listenToClientCheckout(restaurantId: restaurant.id,
                                                          tableId: table.id,
                                                          userId: UserDefaults.standard.getLoggedUser()?.uid ?? "")
            .subscribe(onNext: handleSuccess)
            .disposed(by: disposeBag)
    }
    
    func showAlert(with alertModel: ShowAlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: alertModel.preferredStyle)
        alert.addAction(UIAlertAction(title: alertModel.actionTitle,
                                      style: alertModel.actionStyle))
        alertModel.viewControllerRef.present(alert, animated: true)
    }
    
    //MARK: - Dependency injections
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
