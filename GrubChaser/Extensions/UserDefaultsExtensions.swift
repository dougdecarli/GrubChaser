//
//  UserDefaultsExtensions.swift
//  GrubChaser
//
//  Created by Douglas Immig on 10/09/22.
//

import Foundation

enum UserDefaultsKeys: String {
    case loggedUser
}

extension UserDefaults {
    
    func saveLoggedUser(_ userModel: GrubChaserUserModel) {
        if let userEncoded = try? JSONEncoder().encode(userModel) {
            UserDefaults.standard.set(userEncoded,
                                      forKey: UserDefaultsKeys.loggedUser.rawValue)
        }
    }
    
    func getLoggedUser() -> GrubChaserUserModel? {
        let userData = UserDefaults.standard.object(forKey: UserDefaultsKeys.loggedUser.rawValue)
        guard let data = userData as? Data else {
            return nil
        }
        let userModel = try? JSONDecoder().decode(GrubChaserUserModel.self, from: data)
        return userModel
    }
    
    func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
