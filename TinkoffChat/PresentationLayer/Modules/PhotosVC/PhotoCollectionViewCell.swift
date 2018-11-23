//
//  PhotoCollectionViewCell.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let idenfitifier: String = "PhotoCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    var photoDisplayModel: PhotoDisplayModel?
    func configure(image: UIImage, photoDisplayModel: PhotoDisplayModel) {
        self.imageView.image = image
        self.photoDisplayModel = photoDisplayModel
    }
}
