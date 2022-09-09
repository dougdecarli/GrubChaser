//
//  GrubChaserStarter.swift
//  GrubChaser
//
//  Created by Douglas Immig on 07/09/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class GrubChaserStarter {
    static func startFlow(window: UIWindow?) {
        //TODO: Verify user is logged
        let service = GrubChaserService(dbFirestore: Firestore.firestore())
        GrubChaserLoginRouter(window: window,
                              service: service)
        .start()
    }
}
 
