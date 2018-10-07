//
//  ConversationsView.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation


protocol ConversationsView: class {
    func loadMassage(massageText: [MassageTextModel])
    func updateUI()
}

extension ConversationsView {
    func loadMassage(massageText: [MassageTextModel]) {}
    func updateUI() {}
}
