//
//  GrubChaserRestaurantDetailsViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 29/08/22.
//

import UIKit
import RxDataSources

class GrubChaserRestaurantDetailsViewController: GrubChaserBaseViewController<GrubChaserRestaurantDetailsViewModel> {
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias ProductsSectionModel = SectionModel<String, GrubChaserProduct>
    typealias RestaurantDetailDataSource = RxCollectionViewSectionedReloadDataSource<ProductsSectionModel>
    
    lazy var dataSource = RestaurantDetailDataSource(configureCell: { (dataSource, collectionView, indexPath, item) in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GrubChaserProdutsCollectionViewCell.identifier,
                                                         for: indexPath) as? GrubChaserProdutsCollectionViewCell {
            cell.bind(product: item)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }, configureSupplementaryView: { [weak self] (dataSource, collectionView, kind, indexPath) in
        guard let self = self else { return UICollectionReusableView() }
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                        withReuseIdentifier: GrubChaserRestaurantDetailHeaderCollectionReusableView.identifier,
                                                                        for: indexPath) as? GrubChaserRestaurantDetailHeaderCollectionReusableView {
            header.bind(restaurant: self.viewModel.restaurant,
                        distance: self.viewModel.distance)
            return header
        } else {
            return UICollectionReusableView()
        }
    })
    
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
        super.bindInputs()
    }
    
    override func bindOutputs() {
        super.bindInputs()
        
        viewModel.isLoaderShowing
            .asDriver(onErrorJustReturn: false)
            .drive(collectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .productCells
            .map { items -> [ProductsSectionModel] in
                return [ProductsSectionModel(model: "", items: items)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewCells() {
        collectionView.register(UINib(nibName: GrubChaserProdutsCollectionViewCell.nibName,
                                      bundle: .main),
                                forCellWithReuseIdentifier: GrubChaserProdutsCollectionViewCell.identifier)
        
        collectionView.register(UINib(nibName: GrubChaserRestaurantDetailHeaderCollectionReusableView.nibName,
                                              bundle: .main),
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: GrubChaserRestaurantDetailHeaderCollectionReusableView.identifier)
    }
    
    //MARK: Layout setup
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 15,
                                 height: 212.5)
        collectionView.collectionViewLayout = layout
    }
}
