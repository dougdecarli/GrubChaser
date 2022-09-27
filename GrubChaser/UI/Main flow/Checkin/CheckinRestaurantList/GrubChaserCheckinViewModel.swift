//
//  GrubChaserCheckinViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 13/09/22.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

protocol GrubChaserCheckinViewModelProtocol {
    var restaurant: GrubChaserRestaurantModel { get set }
    var tableId: String { get set }
}

class GrubChaserCheckinViewModel: GrubChaserBaseViewModel<GrubChaserCheckinRouterProtocol> {
    var checkinRestaurantCells: Observable<[GrubChaserRestaurantModel]> {
        setupCheckinRestaurantCells()
    }
    
    var descriptionDriver: Driver<String> {
        setupDescriptionDriver()
    }
    
    let onViewWillAppear = PublishRelay<Void>(),
        onRestaurantTouched = PublishRelay<GrubChaserRestaurantModel>()
    
    private var restaurants = BehaviorRelay<[GrubChaserRestaurantModel]>(value: []),
                userLocation = PublishRelay<[CLLocation]>(),
                locationService: GeolocationService,
                viewControllerRef: UIViewController
    
    internal var showAlert = PublishSubject<ShowAlertModel>(),
                 isLoaderShowing = PublishSubject<Bool>()
    
    init(router: GrubChaserCheckinRouterProtocol,
         locationService: GeolocationService = GeolocationService.instance,
         viewControllerRef: UIViewController) {
        self.viewControllerRef = viewControllerRef
        self.locationService = locationService
        super.init(router: router)
    }
    
    override func setupBindings() {
        setupOnViewWillAppear()
        setupOnRestaurantTouched()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear.asObservable()
            .subscribe(onNext: calculateDistance)
            .disposed(by: disposeBag)
    }
    
    private func setupOnRestaurantTouched() {
        onRestaurantTouched.asObservable()
            .subscribe(onNext: showAlert)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    private func setupDescriptionDriver() -> Driver<String> {
        restaurants
            .map { $0.count > 0 ?
                "Clique no restaurante que deseja realizar o checkin" :
                "Nenhum restaurante próximo"
            }
            .asDriver(onErrorJustReturn: "")
    }
    
    private func setupCheckinRestaurantCells() -> Observable<[GrubChaserRestaurantModel]> {
        restaurants.asObservable()
    }
    
    private func calculateDistance() {
        var nearRestaurants: [GrubChaserRestaurantModel] = []
        guard let userCoordinates = locationService.location else { return }
        if let rests = service.restaurants {
            rests.forEach { restaurant in
                let restaurantCoordinates = CLLocation(latitude: restaurant.location.latitude,
                                                       longitude: restaurant.location.longitude)
                let distance = restaurantCoordinates
                                .distance(from: userCoordinates).rounded(toPlaces: -2)/1000
                if distance <= 0.2 {
                    nearRestaurants.append(restaurant)
                }
            }
            restaurants.accept(nearRestaurants)
        }
    }
    
    //MARK: - Code Verification
    private func showAlert(restaurant: GrubChaserRestaurantModel) {
        let alert = UIAlertController(
            title: "Digite o código para autenticar-se a \(restaurant.name)",
            message: "Ele representa o código da sua mesa",
            preferredStyle: .alert
        )
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Fazer check-in",
                                      style: .default,
                                      handler: { [weak self] alertAction in
            self?.startLoading()
            self?.checkinFromCode(restaurant: restaurant,
                                  code: alert.textFields![0].text ?? "")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar",
                                      style: .cancel))
        viewControllerRef.present(alert, animated: true)
    }
    
    private func checkinFromCode(restaurant: GrubChaserRestaurantModel,
                                 code: String) {
        func handleSuccess(tableId: String?) {
            guard let id = tableId else {
                showAlert.onNext(getAlertErrorModel())
                stopLoading()
                return
            }
            postCheckin(restaurant: restaurant,
                        tableId: id)
        }
        
        func handleError(_ error: Error) {
            stopLoading()
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.checkinFromCode(restaurantId: restaurant.id,
                                code: code)
            .subscribe(onNext: handleSuccess,
                   onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func postCheckin(restaurant: GrubChaserRestaurantModel,
                             tableId: String) {
        func handleSuccess() {
            stopLoading()
            goToRestaurantOrder(restaurant, tableId)
        }
        
        func handleError(_ error: Error) {
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.postTableCheckin(restaurantId: restaurant.id,
                                 tableId: tableId)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    private func goToRestaurantOrder(_ restaurant: GrubChaserRestaurantModel,
                                     _ tableId: String) {
        router.goToCheckinTabBar(restaurant: restaurant,
                                 tableId: tableId)
    }
    
    //MARK: - Helper methods
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
    
    private func getAlertErrorModel() -> ShowAlertModel {
        .init(title: "Não foi possível realizar o check-in",
              message: "Verifique se você digitou o código corretamente",
              viewControllerRef: viewControllerRef)
    }
}

extension GrubChaserCheckinViewModel: GrubChaserAlertableViewModel {}
extension GrubChaserCheckinViewModel: GrubChaserLoadableViewModel {}
