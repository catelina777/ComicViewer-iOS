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
    func didTransition()
}

final class ReadComicPageViewPresenter: ReadComicPagePresenter {

    private weak var view: ReadComicPageView?
    private var user: User
    private var comic: Comic
    private var activity: Activity
    private var currentIndex: Int
    lazy var motionManager = CMMotionManager()
    private var accelerations: [CMAcceleration] = []
    private var gyros: [CMRotationRate] = []
    private var accelerationsDate: [Date] = []

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
        startObserve()
    }

    func viewWillDisappear() {
        stopObserve()
        save()
    }

    func didTransition() {
        stopObserve()
        save()
        startObserve()
    }

    private func startObserve() {
        let deviceQueue = OperationQueue()
        motionManager.deviceMotionUpdateInterval = 0.025
        motionManager.startDeviceMotionUpdates(to: deviceQueue) { [weak self] motionData, _ in
            guard let me = self else { return }
            guard let data = motionData else { return }
            me.accelerations.append(data.userAcceleration)
            me.gyros.append(data.rotationRate)
            let date = Date()
            me.accelerationsDate.append(date)
        }
    }

    private func stopObserve() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }

    private func save() {
        Realm.executeOnMainThread { [weak self] _ in
            guard let me = self else { return }
            let motions = zip(me.accelerations, me.gyros).enumerated().map { index, element in
                Motion(accX: element.0.x, accY: element.0.y, accZ: element.0.z,
                       gyroX: element.1.x, gyroY: element.1.y, gyroZ: element.1.z,
                       date: me.accelerationsDate[index])
            }
            me.activity.motions.append(objectsIn: motions)
            me.accelerations.removeAll()
            me.gyros.removeAll()
            me.accelerationsDate.removeAll()
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
