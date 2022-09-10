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
        let service = GrubChaserService(dbFirestore: Firestore.firestore())
        let loginRouter = GrubChaserLoginRouter(window: window,
                              service: service)
        
        if (UserDefaults.standard.object(forKey: UserDefaultsKeys.loggedUser.rawValue) != nil) {
            loginRouter.goToMainFlow()
        } else {
            loginRouter.start()
        }
    }
}
 
