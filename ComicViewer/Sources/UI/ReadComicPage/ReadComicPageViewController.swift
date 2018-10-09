//
//  ReadComicPageViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ReadComicPageView: class {
    func movePage(to index: Int)
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

    func set(user: User, comic: Comic, currentIndex: Int) {
        presenter = ReadComicPageViewPresenter(view: self,
                                               user: user,
                                               comic: comic,
                                               currentIndex: currentIndex)
    }

    func movePage(to index: Int) {
        guard let destinationVC = presenter.getPage(by: index) else { return }
        self.setViewControllers([destinationVC],
                                direction: .forward,
                                animated: false,
                                completion: nil)
    }
}
