//
//  Realm.extension.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {

    static func execute(_ completion: @escaping(Realm) -> Void) {
        autoreleasepool {
            do {
                let realm = try Realm()
                try realm.write {
                    completion(realm)
                }
            } catch let error {
                print(error)
            }
        }
    }
}
