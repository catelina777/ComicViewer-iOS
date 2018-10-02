//
//  FavoritePagesViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol FavoritePagesPresenter: class {
    init(view: FavoritePagesView, images: [UIImage])
    func showReadComic()
    var numOfImages: Int { get }
    func image(at index: Int) -> UIImage
}

final class FavoritePagesViewPresenter: FavoritePagesPresenter  {

    private weak var view: FavoritePagesView?
    private let images: [UIImage]

    var numOfImages: Int {
        return images.count
    }

    init(view: FavoritePagesView, images: [UIImage]) {
        self.view = view
        self.images = images
    }
}

extension FavoritePagesViewPresenter {

    func showReadComic() {
        view?.showReadComic()
    }

    func image(at index: Int) -> UIImage {
        return images[index]
    }
}
