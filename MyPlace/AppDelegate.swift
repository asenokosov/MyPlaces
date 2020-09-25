//
//  AppDelegate.swift
//  MyPlace
//
//  Created by User on 10/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let schemaVersion: UInt64 = 2
		
		let config = Realm.Configuration(
			schemaVersion: schemaVersion,
			migrationBlock: { migration, oldSchemaVersion in
				if (oldSchemaVersion < schemaVersion) {
				}
			})
		Realm.Configuration.defaultConfiguration = config
		return true
	}
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
}

