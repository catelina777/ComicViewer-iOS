//
//  SelectComicViewController.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/07/27.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

protocol SelectComicView: class {
    func showReadComic(user: User, comic: Comic, index: Int)
    func export()
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

    @objc func export() {
        presenter.export()
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
        self.title = presenter.userName
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                          target: self,
                                          action: #selector(export))
        navigationItem.rightBarButtonItem = saveButton
    }

    func showReadComic(user: User, comic: Comic, index: Int) {
        let vc = R.storyboard.readComic.instantiateInitialViewController()!
        vc.set(user: user,
               comic: comic,
               index: index)
        navigationController?.present(vc,
                                      animated: true,
                                      completion: nil)
    }
}
