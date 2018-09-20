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
    @objc dynamic var date = Date()

    convenience init(index: Int) {
        self.init()
        self.index = index
    }
}
