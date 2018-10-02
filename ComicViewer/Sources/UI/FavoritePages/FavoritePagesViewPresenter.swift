//
//  FavoritePagesViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol FavoritePagesPresenter: class {
    init(view: FavoritePagesView, images: [UIImage], comic: Comic)
    func showReadComic()
    var numOfImages: Int { get }
    func image(at index: Int) -> UIImage
    func like(at index: Int) -> Bool
}

final class FavoritePagesViewPresenter: FavoritePagesPresenter  {

    private weak var view: FavoritePagesView?
    private let images: [UIImage]
    private let comic: Comic

    private lazy var likes: [Bool] = {
        var likes = [Bool].init(repeating: false,
                                count: images.count)
        comic.activities.forEach { activity in
            activity.likes.forEach { like in
                likes[like.index] = true
            }
        }
        return likes
    }()

    var numOfImages: Int {
        return images.count
    }

    init(view: FavoritePagesView, images: [UIImage], comic: Comic) {
        self.view = view
        self.images = images
        self.comic = comic
    }
}

extension FavoritePagesViewPresenter {

    func showReadComic() {
        view?.showReadComic()
    }

    func image(at index: Int) -> UIImage {
        return images[index]
    }

    func like(at index: Int) -> Bool {
        return likes[index]
    }
}
