//
//  MessageManager.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class MessageManager {
    let conversationsPresenter: ConversationsPresenter
    let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    static let shared = MessageManager()
    private init() {
        self.conversationsPresenter = ConversationsPresenter()
    }
}
