//
//  SelectComicCell.swift
//  ComicViewer
//
//  Created by Ryuhei Kaminishi on 2018/07/27.
//  Copyright © 2018 Ryuhei Kaminishi. All rights reserved.
//

import UIKit

class SelectComicCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SelectComicCell {

    func set(with image: UIImage) {
        imageView.image = image
    }
}
