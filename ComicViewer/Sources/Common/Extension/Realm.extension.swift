//
//  Realm.extension.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

var realmConfiguration: Realm.Configuration?

extension Realm {

    static var current: Realm? {
        if let configuration = realmConfiguration {
            return try? Realm(configuration: configuration)
        } else {
            let configuration = Realm.Configuration(
                deleteRealmIfMigrationNeeded: true
            )
            return try? Realm(configuration: configuration)
        }
    }

    static func executeOnMainThread(realm: Realm? = nil, _ execution: @escaping(Realm) -> Void) {
        if let realm = realm {
            try? realm.write {
                execution(realm)
            }
            return
        }

        guard let currentRealm = Realm.current else { return }
        try? currentRealm.write {
            execution(currentRealm)
        }
    }
}
