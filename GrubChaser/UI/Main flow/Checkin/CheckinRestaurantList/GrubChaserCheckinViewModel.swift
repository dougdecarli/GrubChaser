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
    var table: GrubChaserTableModel { get set }
}

final class GrubChaserCheckinViewModel: GrubChaserBaseViewModel<GrubChaserCheckinRouterProtocol> {
    var checkinRestaurantCells: Observable<[GrubChaserRestaurantModel]> {
        setupCheckinRestaurantCells()
    }
    
    var descriptionDriver: Driver<String> {
        setupDescriptionDriver()
    }
    
    let onViewWillAppear = PublishRelay<Void>(),
        onRestaurantTouched = PublishRelay<GrubChaserRestaurantModel>(),
        viewControllerRef: UIViewController,
        locationService: GeolocationService,
        restaurants = BehaviorRelay<[GrubChaserRestaurantModel]>(value: []),
        userTableCheckin = BehaviorRelay<GrubChaserTableModel?>(value: nil)
    
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
            .do(onNext: startLoading(_:))
            .subscribe(onNext: { [weak self] in
                self?.calculateDistance()
                self?.verifyUserHasCheckin()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupOnRestaurantTouched() {
        onRestaurantTouched.asObservable()
            .subscribe(onNext: routeFromRestaurantTouch)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    private func setupDescriptionDriver() -> Driver<String> {
        Observable.combineLatest(restaurants, userTableCheckin)
            .map { nearRestaurants, userTableCheckedIn -> String in
                if nearRestaurants.count > 0 {
                    if userTableCheckedIn != nil {
                        return "Você tem um check-in ativo, clique no restaurante e entre!"
                    } else {
                        return "Clique no restaurante que deseja realizar o checkin"
                    }
                } else {
                    return "Nenhum restaurante próximo"
                }
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
        func handleSuccess(table: GrubChaserTableModel) {
            postCheckin(restaurant: restaurant,
                        table: table)
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
                             table: GrubChaserTableModel) {
        func handleSuccess() {
            stopLoading()
            goToRestaurantOrder(restaurant, table)
        }
        
        func handleError(_ error: Error) {
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.postTableCheckin(restaurantId: restaurant.id,
                                 tableId: table.id,
                                 userModel: UserDefaults.standard.getLoggedUser()!)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Already checked-in verification
    private func verifyUserHasCheckin() {
        func handleSuccess(hasCheckin: GrubChaserTableModel) {
            stopLoading()
            userTableCheckin.accept(hasCheckin)
        }
        
        func handleError(_: Error) {
            stopLoading()
        }
        
        service.isUserChechedIn(restaurantId: restaurants.value.first?.id ?? "",
                                userModel: UserDefaults.standard.getLoggedUser()!)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    private func goToRestaurantOrder(_ restaurant: GrubChaserRestaurantModel,
                                     _ table: GrubChaserTableModel) {
        router.goToCheckinTabBar(restaurant: restaurant,
                                 table: table)
    }
    
    private func routeFromRestaurantTouch(restaurant: GrubChaserRestaurantModel) {
        if let table = userTableCheckin.value {
            goToRestaurantOrder(restaurant, table)
        } else {
            showAlert(restaurant: restaurant)
        }
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
