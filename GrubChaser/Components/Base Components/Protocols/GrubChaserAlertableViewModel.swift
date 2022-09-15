//
//  GrubChaserAlertableViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 09/09/22.
//

import RxRelay
import RxSwift

protocol GrubChaserAlertableViewModel {
    var showAlert: PublishSubject<ShowAlertModel> { get }
}

extension GrubChaserAlertableViewModel {
    func showAlert(with alertModel: ShowAlertModel) {
        showAlert.onNext(alertModel)
    }
    
    func showAlertInput(with alertModel: ShowAlertModel) {
        
    }
}
