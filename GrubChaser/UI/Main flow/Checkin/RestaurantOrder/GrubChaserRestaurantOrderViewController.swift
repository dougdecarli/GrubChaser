//
//  GrubChaserRestaurantOrderViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/09/22.
//

import UIKit
import Foundation

class GrubChaserRestaurantOrderViewController:
    GrubChaserBaseViewController<GrubChaserRestaurantOrderViewModel> {
    @IBOutlet weak var restaurantLogo: UIImageView!
    @IBOutlet weak var restaurantCategory: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionViewBottomConstraint: NSLayoutConstraint!
    
    private let footerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.backgroundColor = UIColor.systemBackground
        return $0
    }(UIView())
    
    private let flowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 50,
                             height: 50)
        $0.minimumInteritemSpacing = 2
        $0.minimumLineSpacing = 3
        return $0
    }(UICollectionViewFlowLayout())
    
    lazy var footerProductsSelectedCollection: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = UIColor.systemBackground
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundView?.backgroundColor = UIColor.clear
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: flowLayout))
    
    private let seeBagButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorPallete.defaultRed
        $0.setTitle("Ver produtos", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.parent?.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupCollectionViewLayout()
        setupCollectionViewCells()
        setupFooterLayout()
        bind()
        
        
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        seeBagButton
            .rx
            .tap
            .bind(to: viewModel.onSeeBagButtonTouched)
            .disposed(by: disposeBag)
        
        productsCollectionView
            .rx
            .modelSelected(GrubChaserProduct.self)
            .bind(to: viewModel.onProductSelected)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        restaurantLogo.loadImage(imageURL: viewModel.restaurant.logo,
                                 genericImage: R.image.genericLogo()!)
        restaurantCategory.text = viewModel.restaurant.categoryName
        restaurantNameLabel.text = viewModel.restaurant.name
        
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
        
        viewModel
            .productsSelectedCells.asObservable()
            .bind(to: footerProductsSelectedCollection.rx.items(cellIdentifier: GrubChaserProductsSelectedCollectionViewCell.identifier,
                                                                cellType: GrubChaserProductsSelectedCollectionViewCell.self)) { (row, element, cell) in
                cell.bind(productImageURL: element.image)
            }.disposed(by: disposeBag)
        
        viewModel.productsSelected
            .map{ !($0.count > 0) }
            .do(onNext: { [weak self] hasNotProductsSelected in
                if hasNotProductsSelected {
                    self?.productsCollectionViewBottomConstraint.constant = 0
                } else {
                    self?.productsCollectionViewBottomConstraint.constant = -90
                }
            })
            .bind(to: footerView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    //MARK: Layout setup
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 15,
                                 height: 212.5)
        productsCollectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewCells() {
        productsCollectionView.register(UINib(nibName: GrubChaserProdutsCollectionViewCell.nibName,
                                              bundle: .main),
                                        forCellWithReuseIdentifier: GrubChaserProdutsCollectionViewCell.identifier)
        
        footerProductsSelectedCollection.register(UINib(nibName: GrubChaserProductsSelectedCollectionViewCell.nibName,
                                                        bundle: .main),
                                                  forCellWithReuseIdentifier: GrubChaserProductsSelectedCollectionViewCell.identifier)
    }
}

//MARK: - Footer
extension GrubChaserRestaurantOrderViewController {
    private func setupFooterLayout() {
        addFooterView()
        setupFooterConstraints()
    }
    
    private func addFooterView() {
        view.add(footerView)
        footerView.add(footerProductsSelectedCollection)
        footerView.add(seeBagButton)
    }
    
    func setupFooterConstraints() {
        footerView
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, -30)
            .leading()
            .trailing()
            .height(50)
        
        footerProductsSelectedCollection
            .top()
            .leading(20)
            .height(50)
            .bottom()
        
        seeBagButton
            .top()
            .trailing(-20)
            .leading(footerProductsSelectedCollection.trailingAnchor, 5)
            .width(UIScreen.main.bounds.width * 0.3)
            .height(50)
    }
}
