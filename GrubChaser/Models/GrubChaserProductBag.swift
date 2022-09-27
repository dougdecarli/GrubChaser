//
//  GrubChaserProductBag.swift
//  GrubChaser
//
//  Created by Douglas Immig on 21/09/22.
//

import Foundation
import Differentiator

struct GrubChaserProductBag: Codable, IdentifiableType, Equatable {
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
    
    let product: GrubChaserProduct
    let quantity: Int
}
