//
//  Profile.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
class ProfileUser {
    var username: String?
    var description: String?
    var avatar: UIImage?
    var usernameWasEdited: Bool = false
    var descriptionWasEdited: Bool = false
    var avatarWasEdited: Bool = false
    init() {}
    init(username: String?, description: String?, avatar: UIImage?) {
        self.username = username
        self.description = description
        self.avatar = avatar
    }
}
