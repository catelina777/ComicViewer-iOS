//
//  FavoritePagesViewDatasource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

final class FavoritePagesViewDatasource: NSObject {

    let presenter: FavoritePagesPresenter
    let itemSpacing: CGFloat = 16

    init(presenter: FavoritePagesPresenter) {
        self.presenter = presenter
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(R.nib.favoriteComicCell)
    }
}
