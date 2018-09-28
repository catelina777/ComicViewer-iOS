//
//  Turn.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/28.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

class Turn: Object {

    @objc dynamic var index = 0
    @objc dynamic var date = Date()

    convenience init(index: Int) {
        self.init()
        self.index = index
    }
}
