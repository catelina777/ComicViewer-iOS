//
//  ReadComicPageViewDatasource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

final class ReadComicPageViewDatasource: NSObject {

    let presenter: ReadComicPagePresenter

    init(presenter: ReadComicPagePresenter) {
        self.presenter = presenter
    }
}

extension ReadComicPageViewDatasource {

    func prepare(with pageViewController: UIPageViewController) {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        let vc = presenter.getCurrentPage()!
        pageViewController.setViewControllers([vc],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
    }
}
