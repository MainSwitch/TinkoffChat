//
//  PhotoRequest.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

class PhotoRequest: IRequest {
    private let baseUrl: String = "https://pixabay.com/"
    private let apiVersion: String = "api/"
    private let search: String = "sun+city"
    private let perPage: String = "120"
    private let imageType: String = "photo"
    private let apiKey: String
    private var urlString: String {
        let params = "key=\(self.apiKey)&q=\(self.search)&image_type=\(self.imageType)&pretty=true&per_page=\(self.perPage)"
        return self.baseUrl + self.apiVersion + "?" + params
    }
    var urlRequest: URLRequest? {
            if let url = URL(string: self.urlString) {
                return URLRequest(url: url)
            }
            return nil
    }
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
