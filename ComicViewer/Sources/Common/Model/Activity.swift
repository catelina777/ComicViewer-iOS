//
//  Activity.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object {

    let likes = List<Like>()
    let turningHistory = List<Turn>()
    let showCounts = List<Int>()

    convenience init(numOfpages: Int) {
        self.init()
        (0..<numOfpages).forEach { _ in
            showCounts.append(0)
        }
    }
}
