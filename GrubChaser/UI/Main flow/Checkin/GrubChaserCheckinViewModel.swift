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
            self?.checkinFromCode(restaurantId: restaurant.id,
                                  code: alert.textFields![0].text ?? "")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar",
                                      style: .cancel))
        viewControllerRef.present(alert, animated: true)
    }
    
    private func checkinFromCode(restaurantId: String,
                                 code: String) {
        func handleSuccess(tableId: String?) {
            guard let id = tableId else {
                showAlert.onNext(getAlertErrorModel())
                stopLoading()
                return
            }
            postCheckin(restaurantId: restaurantId,
                        tableId: id)
        }
        
        func handleError(_ error: Error) {
            stopLoading()
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.checkinFromCode(restaurantId: restaurantId,
                                code: code)
            .subscribe(onNext: handleSuccess,
                   onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func postCheckin(restaurantId: String,
                             tableId: String) {
        func handleSuccess() {
            stopLoading()
            print("Success")
        }
        
        func handleError(_ error: Error) {
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.postTableCheckin(restaurantId: restaurantId,
                                 tableId: tableId)
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
        .init(title: "Não foi possível realizar o check-in",
                               message: "Verifique se você digitou o código corretamente",
                               preferredStyle: .alert,
                               actionStyle: .default,
                               actionTitle: "Ok",
                               viewControllerRef: viewControllerRef)
    }
}

extension GrubChaserCheckinViewModel: GrubChaserAlertableViewModel {}
extension GrubChaserCheckinViewModel: GrubChaserLoadableViewModel {}
