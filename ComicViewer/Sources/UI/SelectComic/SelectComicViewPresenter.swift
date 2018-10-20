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
    var userName: String { get }
    func comicName(at index: Int) -> String
    func coverImage(with name: String) -> UIImage
    func comicPages(with name: String) -> [UIImage]
    func showReadComic(name: String, index: Int)
    func export()
}

final class SelectComicViewPresenter: SelectComicPresenter, Outputtable {

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

    var userName: String {
        return user.name
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
        export(user: user)
    }
}
