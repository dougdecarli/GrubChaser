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
                self?.setupCellButtonsActions(cell, product: element)
                cell.bind(model: element)
            }.disposed(by: disposeBag)
        
        viewModel
            .totalPriceDriver
            .drive(totalPrice.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupCellButtonsActions(_ cell: GrubChaserProductBagTableViewCell,
                                         product: GrubChaserProductBag) {
        cell.plusButton.rx.tap
            .flatMap { Observable.of(product.product) }
            .bind(to: viewModel.onPlusButtonTouched)
            .disposed(by: cell.disposeBag)

        cell.minusButton.rx.tap
            .bind(to: viewModel.onMinusButtonTouched)
            .disposed(by: cell.disposeBag)
    }
    
    private func setupTableViewCells() {
        orderBagTableView.register(UINib(nibName: GrubChaserProductBagTableViewCell.nibName,
                                         bundle: .main),
                                   forCellReuseIdentifier: GrubChaserProductBagTableViewCell.identifier)
    }
}
