//
//  GrubChaserRestaurantDetailsViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 29/08/22.
//

import UIKit

class GrubChaserRestaurantDetailsViewController: GrubChaserBaseViewController<GrubChaserRestaurantDetailsViewModel> {
    
    @IBOutlet weak var restaurantLogo: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewCells()
        title = viewModel.restaurant.name
        bind()
        setupCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear.accept(())
    }
    
    override func bindInputs() {
        
    }
    
    override func bindOutputs() {
        restaurantLogo.downloaded(from: viewModel.restaurant.logo)
        
        viewModel
            .distance
            .asDriver()
            .drive(distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .restaurantCategory
            .asDriver()
            .drive(categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .restaurantAddress
            .asDriver()
            .drive(addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .productCells
            .bind(to: collectionView.rx.items(cellIdentifier: GrubChaserProdutsCollectionViewCell.identifier,
                                              cellType: GrubChaserProdutsCollectionViewCell.self)) { (row, element, cell) in
                cell.bind(product: element)
            }.disposed(by: disposeBag)
    }
    
    private func setupCollectionViewCells() {
        collectionView.register(UINib(nibName: GrubChaserProdutsCollectionViewCell.nibName,
                                      bundle: .main),
                                forCellWithReuseIdentifier: GrubChaserProdutsCollectionViewCell.identifier)
    }
    
    //MARK: Layout setup
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 30,
                                          height: 212.5)
        collectionView.collectionViewLayout = layout
    }
}
