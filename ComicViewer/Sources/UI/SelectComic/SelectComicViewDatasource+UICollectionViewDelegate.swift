//
//  SelectComicViewDatasource+UICollectionViewDelegate.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/09/15.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

extension SelectComicViewDatasource: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let comicName = presenter.comicName(at: indexPath.row)
        presenter.showReadComic(name: comicName,
                                index: 0)
    }
}
