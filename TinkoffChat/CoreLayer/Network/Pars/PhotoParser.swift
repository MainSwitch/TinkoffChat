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
            let docde = try decoder.decode(JSONPhotoModel.self, from: data)
            print(docde)
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            guard let hits = json["hits"] as? [[String: Any]] else {
                return nil
            }
            var photos: [PhotoModel] = []
            for hit in hits {
                guard let photoPreviewURL = hit["previewURL"] as? String,
                    let photoLargeImageURL = hit["largeImageURL"] as? String,
                    let webformatURL = hit["webformatURL"] as? String
                    else { continue }
                photos.append(PhotoModel(previewURL: photoPreviewURL,
                                         largeImageURL: photoLargeImageURL,
                                         webformatURL: webformatURL))
            }
            return photos
        } catch {
            print("error trying to convert data to JSON")
            return nil
        }
    }
}
