//
//  FavoritePagesViewDatasource+UICollectionViewDataSource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension FavoritePagesViewDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.numOfImages
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.favoriteComicCell,
                                                      for: indexPath)!
        let image = presenter.image(at: indexPath.row)
        cell.set(with: image)
        return cell
    }
}
