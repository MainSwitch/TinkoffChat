//
//  ConversationCellConfiguration.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var massage: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMassages: Bool {get set}
}
