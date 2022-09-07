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

class GrubChaserHomeViewController: GrubChaserBaseViewController<GrubChaserHomeViewModel> {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var router: GrubChaserHomeRouterProtocol!,
                locationManager = CLLocationManager(),
                service = GrubChaserService(dbFirestore: Firestore.firestore()),
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
        self.viewModel = GrubChaserHomeViewModel(service: service,
                                                 router: router)
        bindInputs()
        
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func setupHomeRouter() {
        self.router = GrubChaserHomeRouter(navigationController: navigationController ?? UINavigationController(),
                                           service: service)
    }
    
    override func bindInputs() {
        viewModel.restaurantsCoordinates.asObservable()
            .map { coordinates -> [MKPointAnnotation] in
                var annotations = [MKPointAnnotation]()
                coordinates.forEach { coordinate in
                    annotations.append(MKPointAnnotation(__coordinate: coordinate))
                }
                return annotations
            }
            .asDriver(onErrorJustReturn: [])
            .drive(mapView.rx.annotations)
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


