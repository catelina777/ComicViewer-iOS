//
//  SelectComicViewDatasource.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/07/27.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

final class SelectComicViewDatasource: NSObject {

    let presenter: SelectComicPresenter
    let itemSpacing: CGFloat = 8

    init(presenter: SelectComicPresenter) {
        self.presenter = presenter
    }
}

extension SelectComicViewDatasource {

    func prepare(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(R.nib.selectComicCell)
    }
}
