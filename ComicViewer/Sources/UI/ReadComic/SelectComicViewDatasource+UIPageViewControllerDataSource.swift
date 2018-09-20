//
//  SelectComicViewDatasource+UIPageViewControllerDataSource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension ReadComicViewDatasource: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = presenter.getNextPage()
        print("before page")
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = presenter.getPreviousPage()
        print("after page")
        return vc
    }
}
