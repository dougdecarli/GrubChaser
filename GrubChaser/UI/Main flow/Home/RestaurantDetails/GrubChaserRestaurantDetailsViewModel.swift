//
//  GrubChaserRestaurantDetailsViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 29/08/22.
//

import RxSwift
import RxCocoa
import CoreLocation

final class GrubChaserRestaurantDetailsViewModel: GrubChaserBaseViewModel<GrubChaserHomeRouterProtocol> {
    let restaurant: GrubChaserRestaurantModel,
        onViewWillAppear = PublishRelay<Void>(),
        numberOfTables: Int,
        numberOfTablesOccupied: Int
    
    var isLoaderShowing = PublishSubject<Bool>(),
        locationService: GeolocationService
    
    var distance: String {
        calculateDistanceBetweenUser()
    }
    
    var productCells: Observable<[GrubChaserProduct]> {
        setupProductCells()
    }
    
    init(router: GrubChaserHomeRouterProtocol,
         restaurant: GrubChaserRestaurantModel,
         locationService: GeolocationService = GeolocationService.instance,
         numberOfTables: Int,
         numberOfTablesOccupied: Int) {
        self.restaurant = restaurant
        self.locationService = locationService
        self.numberOfTables = numberOfTables
        self.numberOfTablesOccupied = numberOfTablesOccupied
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
    }
    
    //MARK: Outputs
    private func setupProductCells() -> Observable<[GrubChaserProduct]> {
        var cells: [GrubChaserProduct] = []
        restaurant.products.forEach { product in
            cells.append(.init(id: product.id,
                               name: product.name,
                               price: product.price,
                               image: product.image,
                               description: product.description))
        }
        return Observable.of(cells)
    }
    
    //MARK: - Distance between user
    private func calculateDistanceBetweenUser() -> String {
        let restaurantCoordinates = CLLocation(latitude: restaurant.location.latitude,
                                               longitude: restaurant.location.longitude)
        guard let userCoordinates = locationService.location else { return "" }
        return "\(restaurantCoordinates.distance(from: userCoordinates).rounded(toPlaces: -2)/1000)Km"
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
