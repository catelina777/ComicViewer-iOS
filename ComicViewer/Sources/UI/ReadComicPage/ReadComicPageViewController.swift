//
//  ReadComicPageViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ReadComicPageView: class {
    func set(user: User, comic: Comic, images: [UIImage], currentIndex: Int)
    func showSelectComic()
}

final class ReadComicPageViewController: UIPageViewController, ReadComicPageView {

    var presenter: ReadComicPagePresenter!
    private lazy var datasource = ReadComicPageViewDatasource(presenter: self.presenter)

    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.prepare(with: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         presenter.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         presenter.viewWillDisappear()
    }
}

extension ReadComicPageViewController {

    func set(user: User, comic: Comic, images: [UIImage], currentIndex: Int) {
        presenter = ReadComicPageViewPresenter(user: user,
                                               comic: comic,
                                               images: images,
                                               currentIndex: currentIndex)
    }

    func showSelectComic() {
        self.dismiss(animated: true,
                     completion: nil)
    }
}
