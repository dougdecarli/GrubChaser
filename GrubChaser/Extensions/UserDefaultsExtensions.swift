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
    func setObject(value: NSObject, forKey key: String) {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        self.set(data, forKey: key)
    }
    
    func getObject<T>(forKey key: String) -> T? {
        if let saved = UserDefaults.standard.object(forKey: key) as? Data {
            if let instance = NSKeyedUnarchiver.unarchiveObject(with: saved) as? T {
                return instance
            }
        }
        
        return nil
    }
    
    func removeObjects(forKeys keys: [String]) {
        keys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
    }
    
    func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
