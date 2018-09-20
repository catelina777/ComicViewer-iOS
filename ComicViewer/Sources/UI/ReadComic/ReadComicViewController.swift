//
//  ReadComicViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ReadComicView: class {
    func set(user: User, comic: Comic, images: [UIImage], currentIndex: Int)
}

final class ReadComicViewController: UIPageViewController, ReadComicView {

    var presenter: ReadComicPresenter!
    lazy var datasource = ReadComicViewDatasource(presenter: self.presenter)

    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.prepare(with: self)
    }
}

extension ReadComicViewController {

    func set(user: User, comic: Comic, images: [UIImage], currentIndex: Int) {
        presenter = ReadComicViewPresenter(user: user,
                                           comic: comic,
                                           images: images,
                                           currentIndex: currentIndex)
    }
}
