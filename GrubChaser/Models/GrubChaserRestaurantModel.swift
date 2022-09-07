//
//  GrubChaserRestaurantModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 16/08/22.
//

import Foundation
import CodableFirebase
import FirebaseFirestore

struct GrubChaserRestaurantModel: Codable {
    let id: String
    let name: String
    let logo: String
    var location: GrubChaserRestaurantLocationModel
    let products: [GrubChaserProduct]
    let categoryRef: DocumentReference
    var category: GrubChaserRestaurantCategory?
}

struct GrubChaserRestaurantLocationModel: Codable {
    let latitude: Double
    let longitude: Double
}

struct GrubChaserRestaurantCategory: Codable {
    let name: String
}

struct GrubChaserProduct: Codable {
    let name: String
    let price: Double
    let image: String
//    let category: GrubChaserProductCategory
}

struct GrubChaserProductCategory: Codable {
    let name: String
    let image: String
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
