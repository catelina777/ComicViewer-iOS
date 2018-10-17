//
//  Motion.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/01.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

class Motion: Object {

    @objc dynamic var accX: Double = 0
    @objc dynamic var accY: Double = 0
    @objc dynamic var accZ: Double = 0
    @objc dynamic var date = Date()

    convenience init(accX: Double, accY: Double, accZ: Double, date: Date) {
        self.init()
        self.accX = accX
        self.accY = accY
        self.accZ = accZ
        self.date = date
    }
}
