//
//  GrubChaserRestaurantListViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import UIKit

class GrubChaserRestaurantListViewController: GrubChaserBaseViewController<GrubChaserRestaurantListViewModel> {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupTableViewCells()
    }
    
    override func bindInputs() {
        
    }
    
    override func bindOutputs() {
        viewModel
            .restaurantCells
            .bind(to: tableView.rx.items(cellIdentifier: GrubChaserRestaurantTableViewCell.identifier,
                                                    cellType: GrubChaserRestaurantTableViewCell.self)) { (row, element, cell) in
                cell.bind(cellModel: element)
            }.disposed(by: disposeBag)
    }

    private func setupTableViewCells() {
        tableView.register(UINib(nibName: GrubChaserRestaurantTableViewCell.nibName,
                                 bundle: .main),
                           forCellReuseIdentifier: GrubChaserRestaurantTableViewCell.identifier)
    }
}
