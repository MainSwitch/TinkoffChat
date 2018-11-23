//
//  PhotosFacade.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

struct PhotoDisplayModel {
    let imageUrl: String
    let previewImageUrl: String
    let webformatUrl: String
}

protocol IPhotoModelDelegate: class {
    func setup(dataSource: [PhotoDisplayModel])
    func show(error message: String)
}

protocol IPhotosFacade: class {
    var delegate: IPhotoModelDelegate? { get set }
    func fetchYellowFlowers()
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> Void)
}

class PhotosFacade: IPhotosFacade {
    weak var delegate: IPhotoModelDelegate?
    private let photosService: IPhotosService
    init(photosService: IPhotosService) {
        self.photosService = photosService
    }
    func fetchYellowFlowers() {
        self.photosService.loadYellowFlowersPhoto { (photos: [PhotoModel]?, error) in
            if let photosUnwrapped = photos {
                let cell = photosUnwrapped.map({PhotoDisplayModel(imageUrl: $0.largeImageURL, previewImageUrl: $0.previewURL, webformatUrl: $0.webformatURL) })
                self.delegate?.setup(dataSource: cell)
            } else {
                self.delegate?.show(error: error ?? "error")
            }
        }
    }
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        self.photosService.loadImage(urlString: urlString) { (imageModel: ImageModel?, error) in
            if let imageUnwrapped = imageModel {
                completionHandler(imageUnwrapped.image)
            } else {
                completionHandler(nil)
            }
        }
    }
}
