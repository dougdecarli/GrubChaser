//
//  GrubChaserOrderBagViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 21/09/22.
//

import UIKit
import RxSwift

class GrubChaserOrderBagViewController: GrubChaserBaseViewController<GrubChaserOrderBagViewModel> {
    @IBOutlet weak var sendOrderButton: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderBagTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupTableViewCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tabBar = presentingViewController as? UITabBarController,
              let mainNavBar = tabBar.viewControllers![1] as? UINavigationController,
              let checkinTabBar = mainNavBar.topViewController as? GrubChaserCheckinTabBarController,
              let orderNavBar = checkinTabBar.viewControllers![0] as? UINavigationController,
              let presenter = orderNavBar.topViewController as? GrubChaserRestaurantOrderViewController
        else { return }
        presenter.viewModel.productsSelected.accept(viewModel.productsArrayObservable.value)
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        sendOrderButton.rx.tap
            .bind(to: viewModel.onSendOrderButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .productsBagCells
            .bind(to: orderBagTableView.rx.items(cellIdentifier: GrubChaserProductBagTableViewCell.identifier,
                                                 cellType: GrubChaserProductBagTableViewCell.self)) {
                [weak self] (row, element, cell) in
                guard let self = self else { return }
                self.setupCellButtonsActions(cell, product: element)
                cell.bind(model: element)
            }.disposed(by: disposeBag)
        
        viewModel
            .totalPriceDriver
            .drive(totalPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .onSendOrderSuccess
            .subscribe(onNext: goToOrdersVC)
            .disposed(by: disposeBag)
        
        viewModel
            .onEmptyProductsArray
            .subscribe(onNext: dismiss)
            .disposed(by: disposeBag)
    }
    
    private func setupCellButtonsActions(_ cell: GrubChaserProductBagTableViewCell,
                                         product: GrubChaserProductBag) {
        cell.plusButton.rx.tap
            .flatMap { Observable.of(product.product) }
            .bind(to: viewModel.onPlusButtonTouched)
            .disposed(by: cell.rx.disposeBag)

        cell.minusButton.rx.tap
            .flatMap { Observable.of(product.product) }
            .bind(to: viewModel.onMinusButtonTouched)
            .disposed(by: cell.rx.disposeBag)
    }
    
    private func goToOrdersVC() {
        guard let tabBar = presentingViewController as? UITabBarController,
              let mainNavBar = tabBar.viewControllers![1] as? UINavigationController,
              let checkinTabBar = mainNavBar.topViewController as? GrubChaserCheckinTabBarController,
              let orderNavBar = checkinTabBar.viewControllers![0] as? UINavigationController,
              let presenter = orderNavBar.topViewController as? GrubChaserRestaurantOrderViewController
        else { return }
        
        dismiss(animated: true) {
            presenter.viewModel.productsSelected.accept([])
            checkinTabBar.selectedIndex = 1
        }
    }
    
    private func dismiss() {
        dismiss(animated: true)
    }
    
    private func setupTableViewCells() {
        orderBagTableView.register(UINib(nibName: GrubChaserProductBagTableViewCell.nibName,
                                         bundle: .main),
                                   forCellReuseIdentifier: GrubChaserProductBagTableViewCell.identifier)
    }
}
