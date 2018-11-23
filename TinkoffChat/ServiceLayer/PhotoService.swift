//
//  PhotoService.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol IPhotosService {
    func loadYellowFlowersPhoto(completion: @escaping ([PhotoModel]?, String?) -> Void)
    func loadImage(urlString: String, completion: @escaping (ImageModel?, String?) -> Void)
}

class PhotosService: IPhotosService {
    private let requestSender: IRequestSender
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    func loadYellowFlowersPhoto(completion: @escaping ([PhotoModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.ImagesRequests.photoYellowFlowersConfig()
        self.requestSender.send(requestConfig: requestConfig) { (result: Result<[PhotoModel]>) in
            switch result {
            case .success(let photos):
                completion(photos, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    func loadImage(urlString: String, completion: @escaping (ImageModel?, String?) -> Void) {
        let requestConfig = RequestsFactory.ImagesRequests.generateImageConfig(urlString: urlString)
        self.requestSender.send(requestConfig: requestConfig) { (result: Result<ImageModel>) in
            switch result {
            case .success(let photos):
                completion(photos, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
}
