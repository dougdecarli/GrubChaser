//
//  GrubChaserRestaurantDetailsViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 29/08/22.
//

import RxSwift
import RxCocoa
import CoreLocation

class GrubChaserRestaurantDetailsViewModel: GrubChaserBaseViewModel<GrubChaserHomeRouterProtocol> {
    
    let restaurant: GrubChaserRestaurantModel,
        onViewWillAppear = PublishRelay<Void>()
    var restaurantCategory = BehaviorRelay<String>(value: ""),
        restaurantAddress = BehaviorRelay<String>(value: ""),
        distance = BehaviorRelay<String>(value: "")
    private let geoLocationService: GeolocationProtocol
    
    var productCells: Observable<[GrubChaserProductsCellModel]> {
        setupProductCells()
    }
    
    init(service: GrubChaserServiceProtocol,
         router: GrubChaserHomeRouterProtocol,
         geoLocationService: GeolocationProtocol = GeolocationService(),
         restaurant: GrubChaserRestaurantModel) {
        self.restaurant = restaurant
        self.geoLocationService = geoLocationService
        super.init(service: service,
                   router: router)
    }
    
    override func setupBindings() {
        setupOnViewDidLoad()
    }
    
    //MARK: Inputs
    private func setupOnViewDidLoad() {
        onViewWillAppear
            .subscribe(onNext: getRestaurantCategory)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupProductCells() -> Observable<[GrubChaserProductsCellModel]> {
        var cells: [GrubChaserProductsCellModel] = []
        restaurant.products.forEach { product in
            cells.append(.init(image: product.image,
                               price: "R$ \(product.price)",
                               name: product.name))
        }
        return Observable.of(cells)
    }
    
    //MARK: Service
    private func getRestaurantCategory() {
        func handleSuccess(_ category: GrubChaserRestaurantCategory) {
            restaurantCategory.accept(category.name)
            getRestaurantAddress()
        }
        
        func handleError(_ error: Error) {
            getRestaurantAddress()
        }
        
        service.getRestaurantCategory(categoryRef: restaurant.categoryRef)
                .subscribe(onNext: handleSuccess,
                           onError: handleError)
                .disposed(by: disposeBag)
    }
    
    private func getRestaurantAddress() {
        func handleSuccess(address: String) {
            restaurantAddress.accept(address)
            calculateDistanceBetweenUser()
        }
        
        func handleError(_ error: Error) {}
        
        geoLocationService
            .getAddressFromLocation(location: .init(latitude: restaurant.location.latitude,
                                                    longitude: restaurant.location.longitude))
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Distance between user
    private func calculateDistanceBetweenUser() {
        //TODO: get user location -> from user model
        let restaurantCoordinates = CLLocation(latitude: restaurant.location.latitude,
                                               longitude: restaurant.location.longitude)
        let userCoordinates = CLLocation(latitude: -29.745072508165503,
                                         longitude: -51.158768884753655)
        distance
            .accept("\(restaurantCoordinates.distance(from: userCoordinates).rounded(toPlaces: -2)/1000)Km")
    }
}


