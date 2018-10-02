//
//  ComicPageViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol ComicPageView: class {
    func didDoubleTap(sender: UITapGestureRecognizer)
}

final class ComicPageViewController: UIViewController, ComicPageView {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView! {
        didSet {
            likeImageView.image = R.image.favorite()?.withRenderingMode(.alwaysTemplate)
            likeImageView.tintColor = #colorLiteral(red: 0.998013556, green: 0.317686826, blue: 0.3169622719, alpha: 1)
        }
    }

    var presenter: ComicPagePresenter!

    weak var comicImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareGestures()
        self.comicImageView.image = comicImage
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
}

extension ComicPageViewController {

    func set(image: UIImage, user: User, comic: Comic, activity: Activity, index: Int) {
        self.comicImage = image
        presenter = ComicPageViewPresenter(view: self,
                                           user: user,
                                           comic: comic,
                                           activity: activity,
                                           index: index)
    }

    func prepareGestures() {
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(sender:)))
        doubleTapGR.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGR)
    }

    @objc func didDoubleTap(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.view)
        presenter.addFavorite(locX: Double(tapPoint.x),
                              locY: Double(tapPoint.y))
        presenter.animate(with: likeImageView)
    }
}
