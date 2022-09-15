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
        distance = BehaviorRelay<String>(value: ""),
        isLoaderShowing = PublishSubject<Bool>(),
        locationService: GeolocationService
    
    var productCells: Observable<[GrubChaserProductsCellModel]> {
        setupProductCells()
    }
    
    init(router: GrubChaserHomeRouterProtocol,
         restaurant: GrubChaserRestaurantModel,
         locationService: GeolocationService = GeolocationService.instance) {
        self.restaurant = restaurant
        self.locationService = locationService
        super.init(router: router)
    }
    
    override func setupBindings() {
        setupOnViewDidLoad()
    }
    
    //MARK: Inputs
    private func setupOnViewDidLoad() {
        onViewWillAppear
            .subscribe(onNext: calculateDistanceBetweenUser)
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
    
    //MARK: - Distance between user
    private func calculateDistanceBetweenUser() {
        //TODO: get user location -> from user model
        let restaurantCoordinates = CLLocation(latitude: restaurant.location.latitude,
                                               longitude: restaurant.location.longitude)
        guard let userCoordinates = locationService.location else { return }
        distance
            .accept("\(restaurantCoordinates.distance(from: userCoordinates).rounded(toPlaces: -2)/1000)Km")
    }
    
    //MARK: - Helper methods
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension GrubChaserRestaurantDetailsViewModel: GrubChaserLoadableViewModel {}
