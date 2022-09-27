//
//  GrubChaserOrdersViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 23/09/22.
//

import Foundation
import RxDataSources

typealias OrderSectionModel = SectionModel<String, GrubChaserProductBag>
typealias DataSource = RxTableViewSectionedReloadDataSource<OrderSectionModel>

class GrubChaserOrdersViewController: GrubChaserBaseViewController<GrubChaserOrdersViewModel> {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var orderTableView: UITableView!
    
    private let dataSource = DataSource(configureCell: { (dataSource, tableView, indexPath, item) in
        if let cell = tableView.dequeueReusableCell(withIdentifier: GrubChaserOrderTableViewCell.identifier) as? GrubChaserOrderTableViewCell {
            cell.bind(productBag: item)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }, titleForHeaderInSection: { dataSource, indexPath in
        return dataSource[indexPath].model
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear.accept(())
    }
    
    override func bindInputs() {
        super.bindInputs()
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .orderCells
            .startWith([])
            .bind(to: orderTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .totalPrice
            .map { String($0).currencyFormatting() }
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func registerCells() {
        orderTableView.register(UINib(nibName: GrubChaserOrderTableViewCell.nibName,
                                      bundle: .main),
                                forCellReuseIdentifier: GrubChaserOrderTableViewCell.identifier)
    }
}
