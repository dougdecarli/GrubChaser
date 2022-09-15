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
    
    private var restaurants: [GrubChaserRestaurantModel]
    let onRestaurantCellTouched = PublishRelay<GrubChaserRestaurantModel>()
    var restaurantCells: Observable<[GrubChaserRestaurantModel]> {
        setupRestaurantCells()
    }
    
    private var restaurantAddress: String = ""
    
    init(router: GrubChaserHomeRouterProtocol,
         restaurants: [GrubChaserRestaurantModel]) {
        self.restaurants = restaurants
        super.init(router: router)
    }
    
    override func setupBindings() {
        setupOnRestaurantCellTouched()
    }
    
    //MARK: Inputs
    private func setupOnRestaurantCellTouched() {
        onRestaurantCellTouched
            .subscribe(onNext: goToRestaurantDetail)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupRestaurantCells() -> Observable<[GrubChaserRestaurantModel]> {
        var cells: [GrubChaserRestaurantModel] = []
        restaurants.forEach ({ restaurant in
            cells.append(restaurant)
        })
        return Observable.of(cells)
    }
    
    //MARK: Navigation
    private func goToRestaurantDetail(_ restaurant: GrubChaserRestaurantModel) {
        router.goToRestaurantDetails(restaurant: restaurant)
    }
}
