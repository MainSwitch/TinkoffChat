//
//  ImageRequest.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    var urlString: String
    var urlRequest: URLRequest? {
        if let url = URL(string: self.urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    init(urlString: String) {
        self.urlString = urlString
    }
}
