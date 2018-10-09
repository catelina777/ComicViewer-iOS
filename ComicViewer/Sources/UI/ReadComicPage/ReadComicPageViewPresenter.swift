//
//  ReadComicPageViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit
import RealmSwift
import CoreMotion

protocol ReadComicPagePresenter: class {
    init(view: ReadComicPageView, user: User, comic: Comic, currentIndex: Int)
    func getPage(by index: Int) -> ComicPageViewController?
    func getCurrentPage() -> ComicPageViewController?
    func getPreviousPage() -> ComicPageViewController?
    func getNextPage() -> ComicPageViewController?
    func updateCurrentIndex(index: Int)
    func recordDisplayedPage(at index: Int)
    func viewDidAppear()
    func viewWillDisappear()
    func didReceiveMemoryWarning()
    var isTransitioning: Bool { get }
    func set(isTransitioning: Bool)
    func movePage(to index: Int)
    func page(at index: Int) -> UIImage?
}

final class ReadComicPageViewPresenter: ReadComicPagePresenter {

    private weak var view: ReadComicPageView?
    private var user: User
    private var comic: Comic
    private var activity: Activity
    private var currentIndex: Int
    lazy var motionManager = CMMotionManager()
    private var accelerations: [CMAcceleration] = []

    var isTransitioning = false

    lazy var numOfImages: Int = {
        let paths = Bundle.main.paths(forResourcesOfType: "jpg",
                                      inDirectory: comic.name)
        return paths.count
    }()

    init(view: ReadComicPageView, user: User, comic: Comic, currentIndex: Int) {
        self.view = view
        self.user = user
        self.comic = comic
        self.activity = comic.activities.sorted(byKeyPath: "date", ascending: false).first!
        self.currentIndex = currentIndex
    }
}

extension ReadComicPageViewPresenter {

    func getPage(by index: Int) -> ComicPageViewController? {
        let vc = R.storyboard.comicPage.instantiateInitialViewController()!
        guard let image = page(at: index) else { return nil }
        vc.set(image: image,
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
        guard currentIndex != numOfImages - 1 else { return nil }
        let nextIndex = self.currentIndex + 1
        let vc = getPage(by: nextIndex)
        return vc
    }

    func updateCurrentIndex(index: Int) {
        currentIndex = index
    }

    func recordDisplayedPage(at index: Int) {
        Realm.executeOnMainThread { [weak self] _ in
            guard let me = self else { return }
            me.activity.showCounts[index] += 1
            let turn = Turn(index: index)
            me.activity.turningHistory.append(turn)
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
    }

    func set(isTransitioning: Bool) {
        self.isTransitioning = isTransitioning
    }

    func movePage(to index: Int) {
        currentIndex = index
        view?.movePage(to: index)
    }

    func page(at index: Int) -> UIImage? {
        let fileNameIndex = index + 1
        guard let path = Bundle.main.path(forResource: "\(fileNameIndex)",
            ofType: "jpg",
            inDirectory: comic.name)
        else { return nil }

        return UIImage(contentsOfFile: path)
    }
}
