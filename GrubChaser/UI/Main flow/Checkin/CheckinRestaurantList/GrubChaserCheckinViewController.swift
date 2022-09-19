//
//  GrubChaserCheckinViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 13/09/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import RxSwift
import RxCocoa
import MapKit
import RxMKMapView

class GrubChaserCheckinViewController: GrubChaserBaseViewController<GrubChaserCheckinViewModel> {
    @IBOutlet weak var checkinCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var router: GrubChaserCheckinRouterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.router = GrubChaserCheckinRouter(navigationController: navigationController ?? UINavigationController())
        
        self.viewModel = GrubChaserCheckinViewModel(router: router,
                                                    viewControllerRef: self)
        setupCollectionViewCells()
        bind()
        setupCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.onViewWillAppear.accept(())
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        checkinCollectionView
            .rx
            .modelSelected(GrubChaserRestaurantModel.self)
            .bind(to: viewModel.onRestaurantTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel.descriptionDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .checkinRestaurantCells.asObservable()
            .bind(to: checkinCollectionView.rx.items(cellIdentifier: GrubChaserRestaurantCheckinCollectionViewCell.identifier,
                                              cellType: GrubChaserRestaurantCheckinCollectionViewCell.self)) { (row, element, cell) in
                cell.bind(cellModel: element)
            }.disposed(by: disposeBag)
    }
    
    private func setupCollectionViewCells() {
        checkinCollectionView.register(UINib(nibName: GrubChaserRestaurantCheckinCollectionViewCell.nibName,
                                      bundle: .main),
                                forCellWithReuseIdentifier: GrubChaserRestaurantCheckinCollectionViewCell.identifier)
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 145,
                                          height: 160)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        checkinCollectionView.collectionViewLayout = layout
    }
}
