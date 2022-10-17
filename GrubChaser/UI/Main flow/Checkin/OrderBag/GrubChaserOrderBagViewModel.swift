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

final class GrubChaserOrderBagViewModel: GrubChaserBaseViewModel<GrubChaserCheckinMenuRouterProtocol>,
                                   GrubChaserCheckinViewModelProtocol {
    let products: [GrubChaserProduct],
        viewControllerRef: UIViewController,
        onMinusButtonTouched = PublishRelay<GrubChaserProduct>(),
        onPlusButtonTouched = PublishRelay<GrubChaserProduct>(),
        onSendOrderButtonTouched = PublishRelay<Void>(),
        onSendOrderSuccess = PublishRelay<Void>(),
        onEmptyProductsArray = PublishRelay<Void>()
    
    var isLoaderShowing = PublishSubject<Bool>(),
        showAlert = PublishSubject<ShowAlertModel>(),
        restaurant: GrubChaserRestaurantModel,
        table: GrubChaserTableModel
    
    var productsBagCells: Observable<[GrubChaserProductBag]> {
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
    
    init(router: GrubChaserCheckinMenuRouterProtocol,
         products: [GrubChaserProduct],
         restaurant: GrubChaserRestaurantModel,
         table: GrubChaserTableModel,
         viewControllerRef: UIViewController) {
        self.products = products
        self.restaurant = restaurant
        self.table = table
        self.viewControllerRef = viewControllerRef
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnSendOrderButtonTouched()
        setupOnPlusButtonTouched()
        setupOnMinusButtonTouched()
        observeProductsArrayAreEqualToZero()
    }
    
    //MARK: - Inputs
    private func setupOnSendOrderButtonTouched() {
        onSendOrderButtonTouched
            .withLatestFrom(productsBagCells)
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
    
    private func setupOnMinusButtonTouched() {
        onMinusButtonTouched
            .subscribe(onNext: removeProductBag)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    private func segregateProducts() -> Observable<[GrubChaserProductBag]> {
        productsArrayObservable
            .map { products -> [GrubChaserProductBag] in
                products
                    .reduce(into: [GrubChaserProduct:Int]()) { partialResult, nextProduct in
                        partialResult[nextProduct, default: 0] += 1
                    }.map(GrubChaserProductBag.init(product:quantity:))
            }
    }
    
    private func observeProductsArrayAreEqualToZero() {
        productsArrayObservable
            .filter { $0.count == 0 }
            .map { _ in }
            .subscribe(onNext: onEmptyProductsArray.accept)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func postOrder(order: GrubChaserOrderModel) {
        func handleSuccess(orderRef: DocumentReference) {
            saveOrderIdIntoDocument(orderRef: orderRef)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(buildAlertModel())
        }
        
        service.postOrder(restaurantId: restaurant.id, tableId: table.id, order: order)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func saveOrderIdIntoDocument(orderRef: DocumentReference) {
        func handleSuccess() {
            stopLoading()
            onSendOrderSuccess.accept(())
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(buildAlertModel())
        }
        
        service.putOrderIdIntoDocument(orderRef: orderRef)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper methods
    private func addProductBag(product: GrubChaserProduct) {
        productsArrayObservable.accept(productsArrayObservable.value + [product])
    }
    
    private func removeProductBag(product: GrubChaserProduct) {
        var auxProductArray = productsArrayObservable.value
        auxProductArray.removeLast()
        productsArrayObservable.accept(auxProductArray)
    }
    
    private func buildOrderModel(products: [GrubChaserProductBag]) -> Observable<GrubChaserOrderModel> {
        .just(.init(userId: UserDefaults.standard.getLoggedUser()?.uid ?? "",
                    userName: UserDefaults.standard.getLoggedUser()?.name ?? "",
                    tableId: table.id,
                    tableName: table.name,
                    products: products,
                    status: .waitingConfirmation,
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
 




