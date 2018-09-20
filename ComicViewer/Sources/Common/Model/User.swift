//
//  User.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {

    @objc dynamic var name = ""
    let comics = List<Comic>()

    override static func primaryKey() -> String? {
        return "name"
    }

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
