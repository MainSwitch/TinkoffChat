//
//  MessageCellConfiguration.swift
//  tinkoffChat
//
//  Created by Anton on 17/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol MessageCellConfiguration: class {
    var text: String? {get set}
    var isIncoming: Bool {get set}
}
