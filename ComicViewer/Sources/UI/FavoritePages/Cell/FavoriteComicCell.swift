//
//  FavoriteComicCell.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/10/02.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

final class FavoriteComicCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FavoriteComicCell {

    func set(image: UIImage, isFavorite: Bool) {
        imageView.image = image
        favoriteImageView.isHidden = !isFavorite
    }
}
