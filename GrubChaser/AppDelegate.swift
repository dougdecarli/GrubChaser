//
//  AppDelegate.swift
//  GrubChaser
//
//  Created by Douglas Immig on 18/08/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

