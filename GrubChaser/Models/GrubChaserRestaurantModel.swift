//
//  GrubChaserRestaurantModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 16/08/22.
//

import Foundation
import CodableFirebase
import FirebaseFirestore
import Differentiator

struct GrubChaserRestaurantModel: Codable {
    let id: String
    let name: String
    let logo: String
    let categoryName: String
    var location: GrubChaserRestaurantLocationModel
    let products: [GrubChaserProduct]
    var category: GrubChaserRestaurantCategory?
}

struct GrubChaserRestaurantLocationModel: Codable {
    let latitude: Double
    let longitude: Double
    let address: String
}

struct GrubChaserRestaurantCategory: Codable {
    let name: String
}

struct GrubChaserProduct: Codable, Hashable, IdentifiableType, Equatable {
    let id: String
    let name: String
    let price: Double
    let image: String
    let description: String
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
}

struct GrubChaserProductCategory: Codable {
    let name: String
    let image: String
}

struct GrubChaserTable: Codable {
    let id: String
    let code: String
    let isOccupied: Bool
}

extension DocumentReference: DocumentReferenceType {}
