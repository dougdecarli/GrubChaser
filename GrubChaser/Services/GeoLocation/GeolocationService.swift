//
//  GeolocationMock.swift
//  AppEventos
//
//  Created by Douglas Immig on 28/04/20.
//  Copyright © 2020 Douglas de Carli Immig. All rights reserved.
//

import Foundation
import RxSwift
import Contacts
import CoreLocation
import MapKit
import Social
import RxCocoa

protocol GeolocationProtocol {
    func getAddressFromLocation(location: CLLocation) -> Observable<String>
}

final class GeolocationService: GeolocationProtocol {
    
    init() {}
    
    func getAddressFromLocation(location: CLLocation) -> Observable<String> {
        Observable.create { observable -> Disposable in
            CLGeocoder().reverseGeocodeLocation(location,
                                                preferredLocale: nil) { (clPlacemark: [CLPlacemark]?,
                                                                         error: Error?) in
                if let err = error {
                    observable.onError(err)
                } else if let place = clPlacemark?.first {
                    let simpleAddressBuilder = SimpleAddressBuilder()
                    let director = LocationAddressDirector(builder: simpleAddressBuilder)
                    let address = director.makeSimpleAddress(postalAddress: place.postalAddress)
                    observable.onNext(address)
                }
                observable.onCompleted()
            }
            return Disposables.create{}
        }
    }
}

protocol LocationAddressBuilder {
    func reset()
    func buildStreet(_ street: String?)
    func buildCity(_ city: String?)
    func buildState(_ state: String?)
    func buildCountry(_ country: String?)
    func buildPostalCode(_ postalCode: String?)
    func buildSubAdminstrativeArea(_ subAdminstrativeArea: String?)
    func getAddress() -> String
}

class SimpleAddressBuilder: LocationAddressBuilder {
    
    var address: String = ""
    var isStarter = true
    
    init() {
        reset()
    }
    
    func reset() {
        self.address = ""
    }
    
    func buildStreet(_ street: String?) {
        appendAddress(street)
    }
    
    func buildCity(_ city: String?) {
        appendAddress(city)
    }
    
    func buildState(_ state: String?) {
        appendAddress(state)
    }
    
    func buildCountry(_ country: String?) {
        appendAddress(country)
    }
    
    func buildPostalCode(_ postalCode: String?) {
        appendAddress(postalCode)
    }
    
    func buildSubAdminstrativeArea(_ subAdminstrativeArea: String?) {
        appendAddress(subAdminstrativeArea)
    }
    
    func appendAddress(_ addressType: String?) {
        address = [address, addressType]
            .compactMap { $0 }
            .filter { $0 != "" }
            .joined(separator: ", ")
    }
    
    func getAddress() -> String {
        return address
    }
}

class LocationAddressDirector {
    let builder: LocationAddressBuilder
    
    init(builder: LocationAddressBuilder) {
        self.builder = builder
    }
    
    func makeSimpleAddress(postalAddress: CNPostalAddress?) -> String {
        builder.buildStreet(postalAddress?.street)
        builder.buildCity(postalAddress?.city)
        builder.buildState(postalAddress?.state)
        return builder.getAddress()
    }
}
