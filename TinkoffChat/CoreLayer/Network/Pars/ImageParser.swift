//
//  ImageParser.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

struct ImageModel {
    let image: UIImage
}
class ImageParser: IParser {
    typealias Model = ImageModel
    func parse(data: Data) -> ImageParser.Model? {
        if let image = UIImage(data: data) {
            return ImageModel(image: image)
        }
        return nil
    }
}
