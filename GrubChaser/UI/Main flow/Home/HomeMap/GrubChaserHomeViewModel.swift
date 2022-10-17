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

final class GrubChaserHomeViewModel: GrubChaserBaseViewModel<GrubChaserHomeRouterProtocol> {
    
    let restaurants = BehaviorRelay<[GrubChaserRestaurantModel]>(value: []),
        restaurantsCoordinates = PublishRelay<[CLLocationCoordinate2D]>()
    
    override init(router: GrubChaserHomeRouterProtocol) {
        super.init(router: router)
        getRestaurants()
    }
    
    //MARK: Service
    private func getRestaurants() {
        func handleSuccess(_ model: [GrubChaserRestaurantModel]) {
            self.restaurants.accept(model)
            service.restaurants = model
        }
        
        func handleError(_ error: Error) {
            print(error)
        }
        
        service.getRestaurants()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    func goToRestaurantsList() {
        router.goToRestaurantList(restaurants: restaurants.value)
    }
    
    func presentRestaurantDetail(_ restaurant: GrubChaserRestaurantModel) {
        router.goToRestaurantDetailsFromMap(restaurant: restaurant)
    }
}
