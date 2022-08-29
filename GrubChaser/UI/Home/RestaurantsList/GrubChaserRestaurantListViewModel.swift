//
//  GrubChaserRestaurantListViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import Foundation
import RxSwift
import RxCocoa

class GrubChaserRestaurantListViewModel: GrubChaserBaseViewModel<GrubChaserHomeRouterProtocol> {
    
    private let restaurants: [GrubChaserRestaurantModel]
    
    var restaurantCells: Observable<[GrubChaserRestaurantCellModel]> {
        setupRestaurantCells()
    }
    
    init(service: GrubChaserServiceProtocol,
         router: GrubChaserHomeRouterProtocol,
         restaurants: [GrubChaserRestaurantModel]) {
        self.restaurants = restaurants
        super.init(service: service,
                   router: router)
    }
    
    override func setupBindings() {
        
    }
    
    //MARK: Outputs
    private func setupRestaurantCells() -> Observable<[GrubChaserRestaurantCellModel]> {
        var cells: [GrubChaserRestaurantCellModel] = []
        restaurants.forEach ({ restaurant in
            cells.append(.init(restaurantImage: R.image.restaurantIcon()!,
                               restaurantName: restaurant.name))
        })
        return Observable.of(cells)
    }
}
