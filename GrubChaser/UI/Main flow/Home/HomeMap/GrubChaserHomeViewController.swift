//
//  GrubChaserHomeViewController.swift
//  GrubChaser
//
//  Created by Douglas Immig on 15/08/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import RxSwift
import RxCocoa
import MapKit
import RxMKMapView
import RxDataSources

final class GrubChaserHomeViewController: GrubChaserBaseViewController<GrubChaserHomeViewModel> {
    @IBOutlet weak var mapView: MKMapView!
    
    private var router: GrubChaserHomeRouterProtocol!,
                locationManager = CLLocationManager(),
                region = BehaviorRelay<MKCoordinateRegion>(value: MKCoordinateRegion())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.userTrackingMode = .follow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeRouter()
        self.viewModel = GrubChaserHomeViewModel(router: router)
        bind()
        
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func setupHomeRouter() {
        self.router = GrubChaserHomeRouter(navigationController: navigationController ?? UINavigationController())
    }
    
    override func bindInputs() {
        super.bindInputs()
        viewModel.restaurants.asObservable()
            .map { restaurants -> [RestaurantAnnotation] in
                var annotations = [RestaurantAnnotation]()
                restaurants.forEach { restaurant in
                    let annotation = RestaurantAnnotation(restaurant: restaurant)
                    annotation.title = restaurant.name
                    annotations.append(annotation)
                }
                return annotations
            }
            .asDriver(onErrorJustReturn: [])
            .drive(mapView.rx.annotations)
            .disposed(by: disposeBag)
        
        mapView
            .rx
            .didSelectAnnotationView
            .map(\.annotation)
            .subscribe(onNext: { [weak self] annotationTouched in
                guard let annotation = annotationTouched as? RestaurantAnnotation else { return }
                self?.viewModel.presentRestaurantDetail(annotation.restaurant)
            })
            .disposed(by: disposeBag)
        
        mapView
            .rx
            .didUpdateUserLocation
            .map { location -> MKCoordinateRegion in
                let locationCenter = CLLocationCoordinate2D(latitude: location
                                                                        .coordinate.latitude,
                                                            longitude: location
                                                                        .coordinate.longitude)
                return MKCoordinateRegion(center: locationCenter,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.005,
                                                                               longitudeDelta: 0.005))
            }
            .bind(to: region)
            .disposed(by: disposeBag)
    }
    
    @IBAction func onListButtonTouched(_ sender: Any) {
        viewModel.goToRestaurantsList()
    }
}

extension GrubChaserHomeViewController: MKMapViewDelegate {}

final class RestaurantAnnotation: MKPointAnnotation {
    let restaurant: GrubChaserRestaurantModel
    
    init(restaurant: GrubChaserRestaurantModel) {
        self.restaurant = restaurant
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: restaurant.location.latitude,
                                                 longitude: restaurant.location.longitude)
    }
}
