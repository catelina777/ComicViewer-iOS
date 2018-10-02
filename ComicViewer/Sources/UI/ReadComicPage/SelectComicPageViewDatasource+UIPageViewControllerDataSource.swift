//
//  SelectComicViewDatasource+UIPageViewControllerDataSource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension ReadComicPageViewDatasource: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard !presenter.isTransitioning
        else { return nil }
        let vc = presenter.getNextPage()
        print("before page")
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard !presenter.isTransitioning
        else { return nil }
        let vc = presenter.getPreviousPage()
        print("after page")
        return vc
    }
}
