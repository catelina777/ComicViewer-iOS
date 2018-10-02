//
//  ReadComicViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ReadComicPresenter: class {
    init(view: ReadComicView, user: User, comic: Comic, images: [UIImage], index: Int)
    var user: User { get }
    var comic: Comic { get }
    var images: [UIImage] { get }
    var index: Int { get }
    func showSelectComic()
    func showAllPages()
    func disappear(menuView: UIView)
}

final class ReadComicViewPresenter: ReadComicPresenter {

    private weak var view: ReadComicView?

    var user: User
    var comic: Comic
    let images: [UIImage]
    var index: Int

    init(view: ReadComicView, user: User, comic: Comic, images: [UIImage], index: Int) {
        self.view = view
        self.user = user
        self.comic = comic
        self.images = images
        self.index = index
    }
}

extension ReadComicViewPresenter {

    func showSelectComic() {
        view?.showSelectComic()
    }

    func showAllPages() {
        view?.showAllPages()
    }

    func disappear(menuView: UIView) {
        menuView.isHidden = !menuView.isHidden
    }
}
