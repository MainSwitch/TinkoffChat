//
//  ConversationsListView.swift
//  tinkoffChat
//
//  Created by Anton on 07/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol ConversationsListView: class {
    func updateData(model: [[MassageModel]]?)
    func updateUI()
}

extension ConversationsListView {
    func updateData(model: [[MassageModel]]?) {}
    func updateUI() {}
}
