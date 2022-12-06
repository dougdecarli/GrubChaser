//
//  GrubChaserOrderModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/09/22.
//

import Foundation

struct GrubChaserOrderModel: Codable {
    let userId: String
    let userName: String
    let tableId: String
    let tableName: String
    let products: [GrubChaserProductBag]
    let status: GrubChaserOrderStatus
    let timestamp: Double
}

enum GrubChaserOrderStatus: String, Codable {
    case waitingConfirmation = "AGUARDANDO CONFIRMAÇÃO"
    case confirmed = "CONFIRMADO"
    case finished = "FINALIZADO"
}
