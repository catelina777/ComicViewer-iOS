//
//  ReadComicViewDatasource+UIPageViewControllerDelegate.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension ReadComicViewDatasource: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            let currentVC = pageViewController.viewControllers![0]
            guard let vc = currentVC as? ComicPageViewController else { return }
            let index = vc.presenter.index
            presenter.updateCurrentIndex(index: index)
            print("transitioned to \(index)")
        }
    }
}
