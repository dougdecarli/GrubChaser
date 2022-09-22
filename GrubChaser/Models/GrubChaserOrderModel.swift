//
//  GrubChaserOrderModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/09/22.
//

import Foundation

struct GrubChaserOrderModel: Codable {
    let userId: String
    let products: [GrubChaserProductBag]
}
