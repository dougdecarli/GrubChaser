//
//  GrubChaserRestaurantOrderViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/09/22.
//

import UIKit

class GrubChaserRestaurantOrderViewController:
    GrubChaserBaseViewController<GrubChaserRestaurantOrderViewModel> {
    @IBOutlet weak var restaurantLogo: UIImageView!
    @IBOutlet weak var restaurantCategory: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupCollectionViewLayout()
        setupCollectionViewCells()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        productsCollectionView
            .rx
            .modelSelected(GrubChaserProduct.self)
            .bind(to: viewModel.onProductSelected)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        self.title = viewModel.restaurant.name
        restaurantLogo.loadImage(imageURL: viewModel.restaurant.logo,
                                 genericImage: R.image.genericLogo()!)
        restaurantCategory.text = viewModel.restaurant.categoryName
        restaurantAddress.text = viewModel.restaurant.location.address
        
        viewModel.isLoaderShowing
            .asDriver(onErrorJustReturn: false)
            .drive(productsCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .productCells
            .bind(to: productsCollectionView.rx.items(cellIdentifier: GrubChaserProdutsCollectionViewCell.identifier,
                                                      cellType: GrubChaserProdutsCollectionViewCell.self)) { (row, element, cell) in
                cell.bind(product: element)
            }.disposed(by: disposeBag)
    }
    
    //MARK: Layout setup
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 30,
                                          height: 212.5)
        productsCollectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewCells() {
        productsCollectionView.register(UINib(nibName: GrubChaserProdutsCollectionViewCell.nibName,
                                              bundle: .main),
                                forCellWithReuseIdentifier: GrubChaserProdutsCollectionViewCell.identifier)
    }
}
