//
//  PhotoParser.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
    let previewURL: String
    let largeImageURL: String
    let webformatURL: String
}
struct JSONPhotoModel: Codable {
    let hits: [PhotoModel]
}

class PhotoParser: IParser {
    typealias Model = [PhotoModel]
    func parse(data: Data) -> PhotoParser.Model? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decode = try decoder.decode(JSONPhotoModel.self, from: data)
            var photos: [PhotoModel] = []
            for hit in decode.hits {
                photos.append(PhotoModel(previewURL: hit.previewURL,
                                         largeImageURL: hit.largeImageURL,
                                         webformatURL: hit.webformatURL))
            }
            return photos
        } catch {
            print("parse error")
            return nil
        }
    }
}
