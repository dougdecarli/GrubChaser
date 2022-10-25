//
//  GrubChaserOrdersViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 23/09/22.
//

import RxSwift
import RxCocoa

final class GrubChaserOrdersViewModel: GrubChaserBaseViewModel<GrubChaserCheckinOrdersRouterProtocol> {
    let onViewWillAppear = PublishRelay<Void>(),
        restaurant: GrubChaserRestaurantModel,
        table: GrubChaserTableModel,
        viewControllerRef: UIViewController
    
    private let ordersSection = BehaviorRelay<[OrderSectionModel]>(value: [])
    
    internal var showAlert = PublishSubject<ShowAlertModel>(),
                 isLoaderShowing = PublishSubject<Bool>()
    
    var orderCells: Observable<[OrderSectionModel]> {
        ordersSection.asObservable()
    }
    
    var orders: [GrubChaserProductBag] = [],
        totalPrice = BehaviorRelay<Double>(value: 0)
    
    init(router: GrubChaserCheckinOrdersRouterProtocol,
         restaurant: GrubChaserRestaurantModel,
         table: GrubChaserTableModel,
         viewControllerRef: UIViewController) {
        self.restaurant = restaurant
        self.table = table
        self.viewControllerRef = viewControllerRef
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        observeOrdersStatus()
        setupOnViewWillAppear()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoading)
            .map { false }
            .subscribe(onNext: getOrders)
            .disposed(by: disposeBag)
    }
    
    private func observeOrdersStatus() {
        service.listenOrderStatusChanged(restaurantId: restaurant.id)
            .map { true }
            .subscribe(onNext: getOrders)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func getOrders(_ fromListener: Bool) {
        func handleSuccess(userOrders: [GrubChaserOrderModel]) {
            stopLoading()
            ordersSection.accept([])
            totalPrice.accept(0)
            userOrders.forEach { order in
                ordersSection.accept(ordersSection.value +
                                     [.init(model: "\(Date.getDateFormatter(timestamp: order.timestamp)) - \(order.status.rawValue)",
                                            items: order.products)])
                var price: Double = 0
                order.products.forEach { productBag in
                    price += productBag.product.price * Double(productBag.quantity)
                }
                totalPrice.accept(totalPrice.value + price)
            }
        }
        
        func handleError(_ error: Error) {
            stopLoading()
            if !fromListener {
                if error is DecodableErrorType {
                    ordersSection.accept([])
                    totalPrice.accept(0)
                    showAlert.onNext(getAlertEmptyErrorModel())
                    return
                }
                showAlert.onNext(getAlertErrorModel())
            }
        }
        
        service.getUserOrdersInTable(restaurantId: restaurant.id,
                                     tableId: table.id,
                                     userId: UserDefaults.standard.getLoggedUser()?.uid ?? "")
            .subscribe(onNext: handleSuccess,
                    onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper methods
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
    
    private func getAlertErrorModel() -> ShowAlertModel {
        .init(title: "Não foi possível recuperar seus pedidos",
              message: "Tente novamente mais tarde",
              viewControllerRef: viewControllerRef)
    }
    
    private func getAlertEmptyErrorModel() -> ShowAlertModel {
        .init(title: "Você ainda não realizou nenhum pedido!",
              message: "",
              viewControllerRef: viewControllerRef)
    }
}

extension GrubChaserOrdersViewModel: GrubChaserLoadableViewModel {}
extension GrubChaserOrdersViewModel: GrubChaserAlertableViewModel {}
 
