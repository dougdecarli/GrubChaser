//
//  GrubChaserRestaurantOrderViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/09/22.
//

import CoreLocation
import RxCocoa
import RxSwift

final class GrubChaserRestaurantOrderViewModel: GrubChaserBaseViewModel<GrubChaserCheckinMenuRouterProtocol>,
                                            GrubChaserCheckinViewModelProtocol {
    var restaurant: GrubChaserRestaurantModel,
        table: GrubChaserTableModel
    
    let onProductSelected = PublishRelay<GrubChaserProduct>(),
        onSeeBagButtonTouched = PublishRelay<Void>()
    
    internal var isLoaderShowing = PublishSubject<Bool>()
    
    var productsSelected = BehaviorRelay<[GrubChaserProduct]>(value: [])
    
    var productCells: Observable<[GrubChaserProduct]> {
        setupProductCells()
    }
    
    var productsSelectedCells: Observable<[GrubChaserProduct]> {
        productsSelected.asObservable()
    }
    
    init(router: GrubChaserCheckinMenuRouterProtocol,
         restaurant: GrubChaserRestaurantModel,
         table: GrubChaserTableModel) {
        self.restaurant = restaurant
        self.table = table
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnProductSelected()
        setupOnSeeBagButtonTouched()
    }
    
    //MARK: Inputs
    private func setupOnProductSelected() {
        onProductSelected
            .subscribe(onNext: openProductModal)
            .disposed(by: disposeBag)
    }
    
    private func setupOnSeeBagButtonTouched() {
        onSeeBagButtonTouched
            .subscribe(onNext: goToOrderBag)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupProductCells() -> Observable<[GrubChaserProduct]> {
        var cells: [GrubChaserProduct] = []
        restaurant.products.forEach { product in
            cells.append(.init(id: product.id,
                               name: product.name,
                               price: product.price,
                               image: product.image,
                               description: product.description))
        }
        return Observable.of(cells)
    }
    
    //MARK: - Navigation
    private func openProductModal(_ product: GrubChaserProduct) {
        router.presentProductModal(product: product)
    }
    
    private func goToOrderBag() {
        router.presentBagOrderModal(products: productsSelected.value,
                                    restaurant: restaurant,
                                    table: table)
    }
    
    //MARK: - Helper methods
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension GrubChaserRestaurantOrderViewModel: GrubChaserLoadableViewModel {}
