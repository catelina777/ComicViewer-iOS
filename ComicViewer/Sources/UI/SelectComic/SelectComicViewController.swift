//
//  SelectComicViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/07/27.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol SelectComicView: class {
    func set(user: User)
    func prepareNavigationBar()
    func showReadComic(user: User, comic: Comic, images: [UIImage], index: Int)
}

final class SelectComicViewController: UIViewController, SelectComicView {

    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: SelectComicPresenter!
    lazy var dataSource: SelectComicViewDatasource = SelectComicViewDatasource(presenter: self.presenter)

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        dataSource.prepare(with: collectionView)
    }
}

extension SelectComicViewController {

    func set(user: User) {
        presenter = SelectComicViewPresenter(view: self,
                                             user: user)
    }

    func prepareNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2418628931, green: 0.2533941567, blue: 0.3443268239, alpha: 1)
        self.title = "Comics"
    }

    func showReadComic(user: User, comic: Comic, images: [UIImage], index: Int) {
        let vc = R.storyboard.readComic.instantiateInitialViewController()!
        vc.set(user: user,
               comic: comic,
               images: images,
               index: index)
        navigationController?.present(vc,
                                      animated: true,
                                      completion: nil)
    }
}
