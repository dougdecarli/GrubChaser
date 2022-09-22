//
//  GrubChaserOrderBagViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 21/09/22.
//

import RxSwift
import RxCocoa

class GrubChaserOrderBagViewModel: GrubChaserBaseViewModel<GrubChaserCheckinRouterProtocol>,
                                   GrubChaserCheckinViewModelProtocol {
    let products: [GrubChaserProduct],
        viewControllerRef: UIViewController,
        onMinusButtonTouched = PublishRelay<Void>(),
        onPlusButtonTouched = PublishRelay<Void>(),
        onSendOrderButtonTouched = PublishRelay<Void>()
    
    var isLoaderShowing = PublishSubject<Bool>(),
        showAlert = PublishSubject<ShowAlertModel>(),
        restaurant: GrubChaserRestaurantModel,
        tableId: String,
        productsBag = BehaviorRelay<[GrubChaserProductBag]>(value: [])
    
    var productsBagCells: Observable<[GrubChaserProductBag]> {
        productsBag.asObservable()
    }
    
    var segregatedProducts: Observable<[GrubChaserProductBag]> {
        segregateProducts()
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
    
    init(router: GrubChaserCheckinRouterProtocol,
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
    
    //MARK: - Outputs
    private func segregateProducts() -> Observable<[GrubChaserProductBag]> {
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
            print("us guri")
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
    private func buildOrderModel(products: [GrubChaserProductBag]) -> Observable<GrubChaserOrderModel> {
        .just(.init(userId: UserDefaults.standard.getLoggedUser()?.uid ?? "", products: productsBag.value))
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
 




