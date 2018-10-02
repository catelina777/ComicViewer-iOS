//
//  ReadComicViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ReadComicView: class {
    func set(user: User, comic: Comic, images: [UIImage], index: Int)
    func showSelectComic()
    func showAllPages()
}

final class ReadComicViewController: UIViewController, ReadComicView {

    @IBOutlet weak var menuView: UIView!

    var readComicPageViewController: ReadComicPageViewController!
    var presenter: ReadComicPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.showSelectComic()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReadComicPageViewController {
            self.readComicPageViewController = vc
            vc.set(user: presenter.user,
                   comic: presenter.comic,
                   images: presenter.images,
                   currentIndex: presenter.index)
        }
    }

    @IBAction func didPressClose(_ sender: Any) {
        presenter.showSelectComic()
    }

    @IBAction func didPressAllPages(_ sender: Any) {
        presenter.showAllPages()
    }
}

extension ReadComicViewController {

    func showSelectComic() {
        self.dismiss(animated: true,
                     completion: nil)
    }

    func showAllPages() {
        let vc = R.storyboard.favoritePages.instantiateInitialViewController()!
        vc.set(images: presenter.images,
               comic: presenter.comic)
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC,
                animated: true,
                completion: nil)
        print("show all pages")
    }

    func set(user: User, comic: Comic, images: [UIImage], index: Int) {
        presenter = ReadComicViewPresenter(view: self,
                                           user: user,
                                           comic: comic,
                                           images: images,
                                           index: index)
    }

    func setGestures() {
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGR.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGR)

        let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
        singleTapGR.require(toFail: doubleTapGR)
        self.view.addGestureRecognizer(singleTapGR)
    }

    @objc func didDoubleTap() {}

    @objc func didSingleTap() {
        presenter.disappear(menuView: menuView)
    }
}
