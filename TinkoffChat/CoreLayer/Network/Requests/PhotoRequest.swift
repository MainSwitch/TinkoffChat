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
    private let perPage: String = "100"
    private let imageType: String = "photo"
    private let apiKey: String
    private var urlString: String {
        let key = "key=\(self.apiKey)&"
        let searchParams = "q=\(self.search)&"
        let type = "image_type=\(self.imageType)&"
        let enablePreety = "pretty=true&"
        let page = "per_page=\(self.perPage)"
        return self.baseUrl + self.apiVersion + "?" + key + searchParams + type + enablePreety + page
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
