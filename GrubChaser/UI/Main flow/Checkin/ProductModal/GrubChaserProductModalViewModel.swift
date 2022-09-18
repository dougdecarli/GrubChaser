//
//  GrubChaserProductModalViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 18/09/22.
//

import Foundation

class GrubChaserProductModalViewModel: GrubChaserBaseViewModel<GrubChaserCheckinRouterProtocol> {
    let product: GrubChaserProduct
    
    init(router: GrubChaserCheckinRouterProtocol,
         product: GrubChaserProduct) {
        self.product = product
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
    }
}
