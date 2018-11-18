//
//  ConversationData.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

class ConversationWrapper {
    init(userID: String, name: String?, message: String?, date: Date?, online: Bool, hasUnreadedMessages: Bool) {
        self.userID = userID
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadedMessages = hasUnreadedMessages
    }
    var userID: String?
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadedMessages: Bool
}
