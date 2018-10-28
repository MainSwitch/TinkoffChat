//
//  jsonMessage.swift
//  tinkoffChat
//
//  Created by Anton on 26/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

struct JsonMessage: Encodable,Decodable {
    let eventType: String
    let messageId: String
    let text: String
}
