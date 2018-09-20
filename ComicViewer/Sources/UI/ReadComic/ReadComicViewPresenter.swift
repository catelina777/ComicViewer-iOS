//
//  ReadComicViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ReadComicPresenter: class {
    init(user: User, comic: Comic, images: [UIImage], currentIndex: Int)
    func getPage(by index: Int) -> ComicPageViewController?
    func getCurrentPage() -> ComicPageViewController?
    func getPreviousPage() -> ComicPageViewController?
    func getNextPage() -> ComicPageViewController?
    func updateCurrentIndex(index: Int)
}

final class ReadComicViewPresenter: ReadComicPresenter {

    private weak var view: ReadComicView?
    private var user: User
    private var comic: Comic
    private let images: [UIImage]
    private var currentIndex: Int
    private let lastIndex: Int

    init(user: User, comic: Comic, images: [UIImage], currentIndex: Int) {
        self.user = user
        self.comic = comic
        self.images = images
        self.currentIndex = currentIndex
        self.lastIndex = images.count - 1
    }
}

extension ReadComicViewPresenter {

    func getPage(by index: Int) -> ComicPageViewController? {
        let vc = R.storyboard.comicPage.instantiateInitialViewController()!
        vc.set(image: self.images[index],
               user: user,
               comic: comic,
               index: index)
        return vc
    }

    func getCurrentPage() -> ComicPageViewController? {
        return getPage(by: currentIndex)
    }

    func getPreviousPage() -> ComicPageViewController? {
        guard currentIndex != 0 else { return nil }
        let previousIndex = self.currentIndex - 1
        let vc = getPage(by: previousIndex)
        return vc
    }

    func getNextPage() -> ComicPageViewController? {
        guard currentIndex != lastIndex else { return nil }
        let nextIndex = self.currentIndex + 1
        let vc = getPage(by: nextIndex)
        return vc
    }

    func updateCurrentIndex(index: Int) {
        currentIndex = index
    }
}
