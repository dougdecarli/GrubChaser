//
//  GrubChaserUIAlertView.swift
//  GrubChaser
//
//  Created by Douglas Immig on 09/09/22.
//

import RxSwift
import RxCocoa
import UIKit

struct ShowAlertModel {
    let title: String?
    let message: String?
    let preferredStyle: UIAlertController.Style
    let actionStyle: UIAlertAction.Style
    let actionTitle: String
    let viewControllerRef: UIViewController
}

class GrubChaserUIAlertView {
    static func showAlert(with alertModel: ShowAlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: alertModel.preferredStyle)
        alert.addAction(UIAlertAction(title: alertModel.actionTitle,
                                      style: alertModel.actionStyle))
        alertModel.viewControllerRef.present(alert, animated: true)
    }
}
