//
//  Outputtable.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/20.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import Foundation
import RealmSwift

protocol Outputtable {
    func export(user: User)
}

extension Outputtable {

    func export(user: User) {
        user.comics.forEach { comic in
            comic.activities.enumerated().forEach { index, activity in
                export(motions: activity.motions,
                       userName: user.name,
                       comicName: comic.name,
                       activityIndex: index)

                export(transitions: activity.turningHistory,
                       userName: user.name,
                       comicName: comic.name,
                       activityIndex: index)

                export(showCounts: activity.showCounts,
                       userName: user.name,
                       comicName: comic.name,
                       activityIndex: index)

                export(likes: activity.likes,
                       userName: user.name,
                       comicName: comic.name,
                       activityIndex: index)
            }
        }
    }

    private func export(motions: List<Motion>, userName: String, comicName: String, activityIndex: Int) {
        let fileName = "\(userName)_\(comicName)_activity\(activityIndex)_acceleration.csv"
        var csv = "accX,accY,accZ,gyroX,gyroY,gyroZ,epoch_time\n"
        motions.forEach {
            let newColumn = "\($0.accX),\($0.accY),\($0.accZ),\($0.gyroX),\($0.gyroY),\($0.gyroZ),\($0.date.timeIntervalSince1970)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func export(transitions: List<Turn>, userName: String, comicName: String, activityIndex: Int) {
        let fileName = "\(userName)_\(comicName)_activity\(activityIndex)_transition.csv"
        var csv = "index,epoch_time\n"
        transitions.forEach {
            let newColumn = "\($0.index),\($0.date.timeIntervalSince1970)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func export(showCounts: List<Int>, userName: String, comicName: String, activityIndex: Int) {
        let fileName = "\(userName)_\(comicName)_activity\(activityIndex)_showCount.csv"
        var csv = "index,count\n"
        showCounts.enumerated().forEach {
            let newColumn = "\($0+1),\($1)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func export(likes: List<Like>, userName: String, comicName: String, activityIndex: Int) {
        let fileName = "\(userName)_\(comicName)_activity\(activityIndex)_like.csv"
        var csv = "index,locX,locY,epoch_time\n"
        likes.forEach {
            let newColumn = "\($0.index),\($0.locX),\($0.locY),\($0.date.timeIntervalSince1970)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func write(csv: String, fileName: String) {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        let path = paths[0].appendingPathComponent(fileName)
        do {
            try csv.write(to: path,
                          atomically: true,
                          encoding: .utf8)
            print("save success \(fileName)")
        } catch let error {
            print(error)
        }
    }
}
