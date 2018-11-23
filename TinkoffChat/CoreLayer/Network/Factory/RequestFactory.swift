//
//  RequestFactory.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct ImagesRequests {
        static func photoYellowFlowersConfig() -> RequestConfig<PhotoParser> {
            let request = PhotoRequest(apiKey: "10781827-b81c1cef649b57da83f843eed")
            return RequestConfig<PhotoParser>(request: request, parser: PhotoParser())
        }
        static func generateImageConfig(urlString: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(urlString: urlString)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
