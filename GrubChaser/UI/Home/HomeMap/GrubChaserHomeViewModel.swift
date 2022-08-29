//
//  GrubChaserHomeViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/08/22.
//

import UIKit
import FirebaseFirestore
import RxSwift
import RxCocoa
import MapKit

class GrubChaserHomeViewModel: GrubChaserBaseViewModel<GrubChaserHomeRouterProtocol> {
    
    var restaurants = [GrubChaserRestaurantModel](),
        restaurantsCoordinates = PublishRelay<[CLLocationCoordinate2D]>()
    
    override init(service: GrubChaserServiceProtocol,
                  router: GrubChaserHomeRouterProtocol) {
        super.init(service: service,
                   router: router)
        getRestaurants()
    }
    
    //MARK: Service
    private func getRestaurants() {
        func handleSuccess(_ model: [GrubChaserRestaurantModel]) {
            self.restaurants = model
            setupRestaurantsCoordinates()
        }
        
        func handleError(_ error: Error) {
            print(error)
        }
        
        service.getRestaurants()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Location setup
    private func setupRestaurantsCoordinates() {
        var coordinates = [CLLocationCoordinate2D]()
        restaurants.forEach { restaurant in
            coordinates.append(CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude))
        }
        restaurantsCoordinates.accept(coordinates)
    }
}
