//
//  SelectComicViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/07/27.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectComicPresenter: class {
    init(view: SelectComicView, user: User)
    var numOfComic: Int { get }
    func comicName(at index: Int) -> String
    func coverImage(with name: String) -> UIImage
    func comicPages(with name: String) -> [UIImage]
    func showReadComic(name: String, index: Int)
    func export()
}

final class SelectComicViewPresenter: SelectComicPresenter {

    private weak var view: SelectComicView?
    private var user: User

    // TODO: Enter names of comics here
    private var comicNames: [String] {
        return [""]
    }

    init(view: SelectComicView, user: User) {
        self.view = view
        self.user = user
    }
}

extension SelectComicViewPresenter {

    var numOfComic: Int {
        return comicNames.count
    }

    func comicName(at index: Int) -> String {
        return comicNames[index]
    }

    func coverImage(with name: String) -> UIImage {
        guard let path = Bundle.main.path(forResource: "\(1)",
                                          ofType: "jpg",
                                          inDirectory: name)
        else { return UIImage() }

        guard let image = UIImage(contentsOfFile: path)
        else { return UIImage() }

        return image
    }

    func comicPages(with name: String) -> [UIImage] {
        let paths = Bundle.main.paths(forResourcesOfType: "jpg",
                                      inDirectory: name)
        var images: [UIImage] = []
        for index in 1...paths.count {
            guard let path = Bundle.main.path(forResource: "\(index)",
                                              ofType: "jpg",
                                              inDirectory: name)
            else { continue }

            guard let image = UIImage(contentsOfFile: path)
            else { continue }
            images.append(image)
        }
        return images
    }

    func showReadComic(name: String, index: Int) {
        let images = comicPages(with: name)
        let comic = self.comic(name: name,
                               numOfPages: images.count)
        view?.showReadComic(user: user,
                            comic: comic,
                            index: comic.bookmarkIndex)
    }

    private func comic(name: String, numOfPages: Int) -> Comic {
        let comics = self.user.comics
            .filter("name == '\(name)'")
        let newActivity = Activity(numOfpages: numOfPages)
        if let comic = comics.first {
            Realm.executeOnMainThread { _ in
                comic.activities.append(newActivity)
            }
            return comic
        } else {
            let comic = Comic(name: name)
            Realm.executeOnMainThread { realm in
                comic.activities.append(newActivity)
                self.user.comics.append(comic)
                realm.add(self.user, update: true)
            }
            return comic
        }
    }

    func export() {
        user.comics.forEach { comic in
            comic.activities.enumerated().forEach { index, activity in
                print(activity.date)
                exportAcceleration(of: comic,
                                   activity: activity,
                                   index: index)

                exportTransition(of: comic,
                                 activity: activity,
                                 index: index)

                exportShowCount(of: comic,
                                activity: activity,
                                index: index)

                exportLike(of: comic,
                           activity: activity,
                           index: index)
            }
        }
    }

    private func exportAcceleration(of comic: Comic, activity: Activity, index: Int) {
        let fileName = "\(user.name)_\(comic.name)_activity\(index)_acceleration.csv"
        var csv = "locX,locY,locZ,epoch_time\n"
        activity.motions.forEach {
            let newColumn = "\($0.accX),\($0.accY),\($0.accZ),\($0.date.timeIntervalSince1970)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func exportTransition(of comic: Comic, activity: Activity, index: Int) {
        let fileName = "\(user.name)_\(comic.name)_activity\(index)_transition.csv"
        var csv = "index,epoch_time\n"
        activity.turningHistory.forEach {
            let newColumn = "\($0.index),\($0.date.timeIntervalSince1970)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func exportShowCount(of comic: Comic, activity: Activity, index: Int) {
        let fileName = "\(user.name)_\(comic.name)_activity\(index)_showCount.csv"
        var csv = "index,count\n"
        activity.showCounts.enumerated().forEach {
            let newColumn = "\($0+1),\($1)\n"
            csv.append(newColumn)
        }
        write(csv: csv,
              fileName: fileName)
    }

    private func exportLike(of comic: Comic, activity: Activity, index: Int) {
        let fileName = "\(user.name)_\(comic.name)_activity\(index)_like.csv"
        var csv = "index,locX,locY,epoch_time\n"
        activity.likes.forEach {
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
