//
//  ComicPageViewPresenter.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/17.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit
import RealmSwift

protocol ComicPagePresenter: class {
    init(view: ComicPageView, user: User, comic: Comic, activity: Activity, index: Int)
    var index: Int { get }
    func showReadComic()
    func disappear(menuView: UIView)
    func animate(with imageView: UIImageView)
    func addFavorite(locX: Double, locY: Double)
    func exportCSV()
}

final class ComicPageViewPresenter: ComicPagePresenter {

    private weak var view: ComicPageView?
    private var user: User
    private var comic: Comic
    private var activity: Activity
    var index: Int

    init(view: ComicPageView, user: User, comic: Comic, activity: Activity, index: Int) {
        self.view = view
        self.user = user
        self.comic = comic
        self.activity = activity
        self.index = index
    }
}

extension ComicPageViewPresenter {

    func showReadComic() {
        putBookmark(at: index)
        exportCSV()
        view?.showReadComic()
    }

    func disappear(menuView: UIView) {
        menuView.isHidden = !menuView.isHidden
    }

    func animate(with imageView: UIImageView) {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .allowUserInteraction,
                       animations: {
            imageView.isHidden = false
            imageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }, completion: { finished in
            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            if finished {
                imageView.isHidden = true
            }
        })
    }

    func addFavorite(locX: Double, locY: Double) {
        Realm.executeOnMainThread { [weak self] _ in
            guard let me = self else { return }
            let like = Like(index: me.index,
                            locX: locX,
                            locY: locY)
            me.activity.likes.append(like)
        }
    }

    func exportCSV() {
        let likes = activity.likes
        let arrayLikes = Array(likes)
        var csv = "epoch_time,index\n"
        let name = "\(comic.name)_\(Date().timeIntervalSince1970).csv"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent(name)
        arrayLikes.forEach {
            let newColumn = "\($0.date.timeIntervalSince1970),\($0.index)\n"
            csv.append(newColumn)
        }
        do {
            try csv.write(to: path, atomically: true, encoding: .utf8)
            print("saved at \(path)")
        } catch let error {
            print(error)
        }
    }

    private func putBookmark(at index: Int) {
        Realm.executeOnMainThread { [weak self] _ in
            guard let me = self else { return }
            me.comic.bookmarkIndex = index
        }
    }
}
