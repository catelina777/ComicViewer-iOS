//
//  Like.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

class Like: Object {

    @objc dynamic var index = -1
    @objc dynamic var locX: Double = 0
    @objc dynamic var locY: Double = 0
    @objc dynamic var date = Date()

    convenience init(index: Int, locX: Double, locY: Double) {
        self.init()
        self.index = index
        self.locX = locX
        self.locY = locY
    }
}
