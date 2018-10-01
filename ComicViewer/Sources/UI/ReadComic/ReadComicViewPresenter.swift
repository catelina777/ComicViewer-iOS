//
//  ReadComicViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit
import RealmSwift
import CoreMotion

protocol ReadComicPresenter: class {
    init(user: User, comic: Comic, images: [UIImage], currentIndex: Int)
    func getPage(by index: Int) -> ComicPageViewController?
    func getCurrentPage() -> ComicPageViewController?
    func getPreviousPage() -> ComicPageViewController?
    func getNextPage() -> ComicPageViewController?
    func updateCurrentIndex(index: Int)
    func recordDisplayedPage(at index: Int)
    func viewDidAppear()
    func viewWillDisappear()
    func didReceiveMemoryWarning()
}

final class ReadComicViewPresenter: ReadComicPresenter {

    private weak var view: ReadComicView?
    private var user: User
    private var comic: Comic
    private var activity: Activity
    private let images: [UIImage]
    private var currentIndex: Int
    private let lastIndex: Int
    private let motionManager = CMMotionManager()
    private var accelerations: [CMAcceleration] = []

    init(user: User, comic: Comic, images: [UIImage], currentIndex: Int) {
        self.user = user
        self.comic = comic
        self.activity = comic.activities.sorted(byKeyPath: "date", ascending: false).first!
        self.images = images
        self.currentIndex = currentIndex
        self.lastIndex = images.count - 1
    }
}

extension ReadComicViewPresenter {

    func getPage(by index: Int) -> ComicPageViewController? {
        let vc = R.storyboard.comicPage.instantiateInitialViewController()!
        vc.set(image: self.images[index],
               user: self.user,
               comic: self.comic,
               activity: self.activity,
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

    func recordDisplayedPage(at index: Int) {
        Realm.executeOnMainThread { _ in
            self.activity.showCounts[index] += 1
            let turn = Turn(index: index)
            self.activity.turningHistory.append(turn)
        }
    }

    func viewDidAppear() {
        let queue = OperationQueue()
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, _ in
            guard let me = self else { return }
            me.accelerations.append(data!.acceleration)
        }
    }

    func viewWillDisappear() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
            Realm.executeOnMainThread { [weak self] _ in
                guard let me = self else { return }
                me.accelerations.forEach { acceleration in
                    let motion = Motion(accX: acceleration.x,
                                        accY: acceleration.y,
                                        accZ: acceleration.z)
                    me.activity.motions.append(motion)
                }
            }
        }
    }

    func didReceiveMemoryWarning() {
        viewWillDisappear()
        view?.showSelectComic()
    }
}
