//
//  GrubChaserRestaurantModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 16/08/22.
//

import Foundation
import CodableFirebase
import FirebaseFirestore

struct GrubChaserRestaurantModel: Decodable {
    let name: String
    let location: GrubChaserRestaurantLocationModel
//    let category: GrubChaserCategory
}

struct GrubChaserRestaurantLocationModel: Decodable {
    let address: String
    let city: String
    let state: String
    let latitude: Double
    let longitude: Double
}

struct GrubChaserCategory: Decodable {
    let name: String
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
