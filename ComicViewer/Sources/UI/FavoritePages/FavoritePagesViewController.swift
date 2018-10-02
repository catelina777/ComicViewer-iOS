//
//  FavoritePagesViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol FavoritePagesView: class {
    func showReadComic()
}

final class FavoritePagesViewController: UIViewController, FavoritePagesView {

    @IBOutlet weak var collectionView: UICollectionView!

    private var presenter: FavoritePagesPresenter!
    private var dataSource: FavoritePagesViewDatasource!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        dataSource.configure(with: collectionView)
    }

    @objc func didPressCloseButton() {
        presenter.showReadComic()
    }
}

extension FavoritePagesViewController {

    func showReadComic() {
        self.dismiss(animated: true,
                     completion: nil)
    }

    func set(images: [UIImage], comic: Comic) {

        presenter = FavoritePagesViewPresenter(view: self,
                                               images: images,
                                               comic: comic)
        dataSource = FavoritePagesViewDatasource(presenter: presenter)
    }

    func prepareNavigationBar() {
        self.title = "All Pages"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2418628931, green: 0.2533941567, blue: 0.3443268239, alpha: 1)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(didPressCloseButton))
        navigationItem.rightBarButtonItem = closeButton
    }
}
