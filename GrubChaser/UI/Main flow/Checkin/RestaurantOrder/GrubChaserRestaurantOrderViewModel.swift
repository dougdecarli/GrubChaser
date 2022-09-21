//
//  GrubChaserRestaurantOrderViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/09/22.
//

import CoreLocation
import RxCocoa
import RxSwift

class GrubChaserRestaurantOrderViewModel: GrubChaserBaseViewModel<GrubChaserCheckinRouterProtocol> {
    let restaurant: GrubChaserRestaurantModel,
        onProductSelected = PublishRelay<GrubChaserProduct>()
    
    internal var isLoaderShowing = PublishSubject<Bool>()
    
    var productsSelected = BehaviorRelay<[GrubChaserProduct]>(value: [])
    
    var productCells: Observable<[GrubChaserProduct]> {
        setupProductCells()
    }
    
    var productsSelectedCells: Observable<[GrubChaserProduct]> {
        productsSelected.asObservable()
    }
    
    init(router: GrubChaserCheckinRouterProtocol,
         restaurant: GrubChaserRestaurantModel) {
        self.restaurant = restaurant
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnProductSelected()
    }
    
    //MARK: Inputs
    private func setupOnProductSelected() {
        onProductSelected
            .subscribe(onNext: openProductModal)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupProductCells() -> Observable<[GrubChaserProduct]> {
        var cells: [GrubChaserProduct] = []
        restaurant.products.forEach { product in
            cells.append(.init(name: product.name,
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
    
    //MARK: - Helper methods
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension GrubChaserRestaurantOrderViewModel: GrubChaserLoadableViewModel {}
