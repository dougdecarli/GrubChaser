//
//  GrubChaserTableModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 06/10/22.
//

import Foundation

struct GrubChaserTableModel: Codable {
    let name: String
    let code: String
    let id: String
    let isOccupied: Bool
}
