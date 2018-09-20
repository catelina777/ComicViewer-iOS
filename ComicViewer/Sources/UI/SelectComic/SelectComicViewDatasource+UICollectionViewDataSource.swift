//
//  SelectComicViewDatasource+UICollectionViewDataSource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension SelectComicViewDatasource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.numOfComic
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicName = presenter.comicName(at: indexPath.row)
        let frontPage = presenter.coverImage(with: comicName)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.selectComicCell,
                                                      for: indexPath)!
        cell.set(with: frontPage)
        return cell
    }
}
