//
//  ComicPageViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ComicPageView: class {
    func showReadComic()
}

final class ComicPageViewController: UIViewController, ComicPageView {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView! {
        didSet {
            likeImageView.image = R.image.favorite()?.withRenderingMode(.alwaysTemplate)
            likeImageView.tintColor = #colorLiteral(red: 0.998013556, green: 0.317686826, blue: 0.3169622719, alpha: 1)
        }
    }

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var allPagesButton: UIButton!

    var presenter: ComicPagePresenter!

    var comicImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareGestures()
        self.comicImageView.image = comicImage
    }

    @IBAction func didPressCloseButton(_ sender: Any) {
        presenter.showReadComic()
    }

    @IBAction func didPressAllPagesButton(_ sender: Any) {

    }
}

extension ComicPageViewController {

    func showReadComic() {
        self.dismiss(animated: true,
                     completion: nil)
    }

    func set(image: UIImage, user: User, comic: Comic, index: Int) {
        self.comicImage = image
        presenter = ComicPageViewPresenter(view: self,
                                           user: user,
                                           comic: comic,
                                           index: index)
    }

    func prepareGestures() {
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGR.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGR)

        let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
        singleTapGR.require(toFail: doubleTapGR)
        self.view.addGestureRecognizer(singleTapGR)
    }

    @objc func didDoubleTap() {
        presenter.addFavorite()
        presenter.animate(with: likeImageView)
    }

    @objc func didSingleTap() {
        presenter.disappear(menuView: menuView)
    }
}
