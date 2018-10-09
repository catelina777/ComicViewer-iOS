//
//  FavoritePagesViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol FavoritePagesPresenter: class {
    init(view: FavoritePagesView, comic: Comic)
    func showReadComic()
    func showReadComic(to index: Int)
    var numOfImages: Int { get }
    func page(at index: Int) -> UIImage?
    func like(at index: Int) -> Bool
}

final class FavoritePagesViewPresenter: FavoritePagesPresenter {

    private weak var view: FavoritePagesView?
    private let comic: Comic

    private lazy var likes: [Bool] = {
        var likes = [Bool].init(repeating: false,
                                count: numOfImages)
        comic.activities.forEach { activity in
            activity.likes.forEach { like in
                likes[like.index] = true
            }
        }
        return likes
    }()

    lazy var numOfImages: Int = {
        let paths = Bundle.main.paths(forResourcesOfType: "jpg",
                                      inDirectory: comic.name)
        return paths.count
    }()

    init(view: FavoritePagesView, comic: Comic) {
        self.view = view
        self.comic = comic
    }
}

extension FavoritePagesViewPresenter {

    func showReadComic() {
        view?.showReadComic()
    }

    func showReadComic(to index: Int) {
        view?.showReadComic(to: index)
    }

    func like(at index: Int) -> Bool {
        return likes[index]
    }

    func page(at index: Int) -> UIImage? {
        let fileNameIndex = index + 1
        guard let path = Bundle.main.path(forResource: "\(fileNameIndex)",
            ofType: "jpg",
            inDirectory: comic.name)
        else { return nil }

        return UIImage(contentsOfFile: path)
    }
}
