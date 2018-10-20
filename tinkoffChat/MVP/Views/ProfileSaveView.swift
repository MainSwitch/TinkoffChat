//
//  ProfileSaveView.swift
//  tinkoffChat
//
//  Created by Anton on 18/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol ProfileSaveView: class {
    func getSaveData()
    func updateUI()
    func loadMainData()
    func loadReductData()
}

extension ProfileSaveView {
    func getSaveData() {}
    func updateUI() {}
    func loadMainData() {}
    func loadReductData() {}
}
