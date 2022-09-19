//
//  GrubChaserProductModalViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 18/09/22.
//

import RxSwift
import RxCocoa

class GrubChaserProductModalViewModel: GrubChaserBaseViewModel<GrubChaserCheckinRouterProtocol> {
    let product: GrubChaserProduct,
        onAddButtonTouched = PublishRelay<Void>(),
        onPlusButtonTouched = PublishRelay<Void>(),
        onMinusButtonTouched = PublishRelay<Void>(),
        dismissModal = PublishSubject<[GrubChaserProduct]>()
    
    lazy var products = BehaviorRelay<[GrubChaserProduct]>(value: [product])
    
    var quantityText: Observable<String> {
        products
            .map { String($0.count) }
    }
    
    var totalPrice: Observable<Double> {
        setupTotalPrice(productPrice: product.price)
    }
    
    var isMinusButtonDisabled: Observable<Bool> {
        setupIsMinusButtonDisabled()
    }
    
    var addButtonTextDriver: Driver<String> {
        setupAddButtonTextDriver()
    }
    
    init(router: GrubChaserCheckinRouterProtocol,
         product: GrubChaserProduct) {
        self.product = product
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnAddButtonTouched()
        setupOnPlusButtonTouched()
        setupOnMinusButtonTouched()
    }
      
    private func setupOnAddButtonTouched() {
        onAddButtonTouched
            .withLatestFrom(products)
            .subscribe(onNext: dismissWithProducts)
            .disposed(by: disposeBag)
    }
    
    private func setupOnPlusButtonTouched() {
        onPlusButtonTouched
            .subscribe(onNext: plusButtonTouched)
            .disposed(by: disposeBag)
    }
    
    private func setupOnMinusButtonTouched() {
        onMinusButtonTouched
            .subscribe(onNext: minusButtonTouched)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    private func setupIsMinusButtonDisabled() -> Observable<Bool> {
        products
            .map { $0.count == 1 }
    }
    
    private func setupAddButtonTextDriver() -> Driver<String> {
        totalPrice
            .map { "Adicionar - \(String($0).currencyFormatting())" }
            .asDriver(onErrorJustReturn: "Adicionar")
    }
    
    private func setupTotalPrice(productPrice: Double) -> Observable<Double> {
        products
            .map { productPrice * Double($0.count) }
    }
    
    //MARK: - Helper methods
    private func plusButtonTouched() {
        products.accept(products.value + [product])
    }
    
    private func minusButtonTouched() {
        var auxProducts = products.value
        _ = auxProducts.removeLast()
        products.accept(auxProducts)
    }
    
    //MARK: - Navigation
    private func dismissWithProducts(products: [GrubChaserProduct]) {
        dismissModal.onNext(products)
    }
}
