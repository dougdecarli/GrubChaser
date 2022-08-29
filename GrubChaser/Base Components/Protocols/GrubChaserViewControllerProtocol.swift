//
//  GrubChaserViewControllerProtocol.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import Foundation

protocol GrubChaserViewControllerProtocol {
    func bindInputs()
    func bindOutputs()
}

extension GrubChaserViewControllerProtocol {
    func bind() {
        bindInputs()
        bindOutputs()
    }
}
