//
//  FavoritePagesViewDatasource+UICollectionViewDelegate.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension FavoritePagesViewDatasource: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.showReadComic(to: indexPath.row)
    }
}
