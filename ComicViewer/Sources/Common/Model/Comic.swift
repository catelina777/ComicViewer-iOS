//
//  Comic.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

class Comic: Object {

    @objc dynamic var name = ""
    @objc dynamic var activity: Activity?
    @objc dynamic var bookmarkIndex = 0
    @objc dynamic var date = Date()

    convenience init(name: String, numOfPages: Int) {
        self.init()
        self.name = name
        self.activity = Activity(numOfpages: numOfPages)
    }
}
