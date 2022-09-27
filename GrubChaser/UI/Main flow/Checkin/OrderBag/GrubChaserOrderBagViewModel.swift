//
//  GrubChaserOrderBagViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 21/09/22.
//

import RxSwift
import RxCocoa
import CodableFirebase
import FirebaseFirestore

class GrubChaserOrderBagViewModel: GrubChaserBaseViewModel<GrubChaserCheckinMenuRouterProtocol>,
                                   GrubChaserCheckinViewModelProtocol {
    let products: [GrubChaserProduct],
        viewControllerRef: UIViewController,
        onMinusButtonTouched = PublishRelay<Void>(),
        onPlusButtonTouched = PublishRelay<GrubChaserProduct>(),
        onSendOrderButtonTouched = PublishRelay<Void>(),
        onSendOrderSuccess = PublishRelay<Void>()
    
    var isLoaderShowing = PublishSubject<Bool>(),
        showAlert = PublishSubject<ShowAlertModel>(),
        restaurant: GrubChaserRestaurantModel,
        tableId: String
    
    var productsBag = BehaviorRelay<[GrubChaserProductBag]>(value: [])
    
    var productsBagCells: Observable<[GrubChaserProductBag]> {
        segregateProducts(products: products)
    }
    
    var segregatedProducts: Observable<[GrubChaserProductBag]> {
        segregateProducts(products: products)
    }
    
    lazy var productsArrayObservable = BehaviorRelay<[GrubChaserProduct]>(value: products)
    
    var totalPriceDriver: Driver<String> {
        productsArrayObservable
            .map { array -> String in
                var totalPrice: Double = 0
                array.forEach { product in
                    totalPrice += product.price
                }
                return String(totalPrice).currencyFormatting()
            }
            .asDriver(onErrorJustReturn: "")
    }
    
    init(router: GrubChaserCheckinMenuRouterProtocol,
         products: [GrubChaserProduct],
         restaurant: GrubChaserRestaurantModel,
         tableId: String,
         viewControllerRef: UIViewController) {
        self.products = products
        self.restaurant = restaurant
        self.tableId = tableId
        self.viewControllerRef = viewControllerRef
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnSendOrderButtonTouched()
        setupOnPlusButtonTouched()
        setupProductsArrayObservable()
        
        segregatedProducts
            .bind(to: productsBag)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Inputs
    private func setupOnSendOrderButtonTouched() {
        onSendOrderButtonTouched
            .withLatestFrom(productsBag)
            .flatMap(buildOrderModel)
            .do(onNext: startLoading)
            .subscribe(onNext: postOrder)
            .disposed(by: disposeBag)
    }
    
    private func setupOnPlusButtonTouched() {
        onPlusButtonTouched
            .subscribe(onNext: addProductBag)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    private func setupProductsArrayObservable() {
        productsArrayObservable
            .flatMap(segregateProducts)
            .bind(to: productsBag)
            .disposed(by: disposeBag)
    }
    
    private func segregateProducts(products: [GrubChaserProduct]) -> Observable<[GrubChaserProductBag]> {
        return Observable
            .of(products
                .reduce(into: [GrubChaserProduct:Int]()) { partialResult, nextProduct in
                    partialResult[nextProduct, default: 0] += 1
                }.map(GrubChaserProductBag.init(product:quantity:)))
    }
    
    //MARK: - Service
    private func postOrder(order: GrubChaserOrderModel) {
        func handleSuccess(_: Any?) {
            stopLoading()
            onSendOrderSuccess.accept(())
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(buildAlertModel())
        }
        
        service.postOrder(restaurantId: restaurant.id, tableId: tableId, order: order)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper methods
    private func addProductBag(product: GrubChaserProduct) {
        productsArrayObservable.accept(productsArrayObservable.value + [product])
    }
    
    private func buildOrderModel(products: [GrubChaserProductBag]) -> Observable<GrubChaserOrderModel> {
        .just(.init(userId: UserDefaults.standard.getLoggedUser()?.uid ?? "",
                    products: productsBag.value,
                    timestamp: Date.now.timeIntervalSince1970))
    }
    
    private func buildAlertModel() -> ShowAlertModel {
        .init(title: "Não foi possível enviar o pedido",
              message: "Tente novamente",
              viewControllerRef: viewControllerRef)
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension GrubChaserOrderBagViewModel: GrubChaserLoadableViewModel {}
extension GrubChaserOrderBagViewModel: GrubChaserAlertableViewModel {}
 




