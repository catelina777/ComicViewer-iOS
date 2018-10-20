//
//  AppDelegate.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/07/27.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareUI()
        print(getRealmPath())
        migrate()
        return true
    }
}

extension AppDelegate {

    private func prepareUI() {
        let settingPageVC = R.storyboard.settingPage.instantiateInitialViewController()!
        let rootVC = UINavigationController(rootViewController: settingPageVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    private func getRealmPath() -> URL {
        return Realm.Configuration.defaultConfiguration.fileURL!
    }

    private func migrate() {
        let config = Realm.Configuration(schemaVersion: 1,
                                         migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {}
        })
        Realm.Configuration.defaultConfiguration = config
    }
}
