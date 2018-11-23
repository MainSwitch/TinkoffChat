//
//  IPhotosViewControllerDelegate.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol IPhotosViewControllerDelegate: class {
    func collectionPickerController(_ picker: PhotosViewController, didFinishPickingImage image: UIImage)
}
