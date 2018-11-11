//
//  MessageModel.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

struct MessageModel {
    let conversationID: String!
    let name: String?
    let message: String?
    let date: Date?
    let online: Bool
    let hasUnreadMessages: Bool
}
