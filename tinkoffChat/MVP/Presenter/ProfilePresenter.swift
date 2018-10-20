//
//  ProfilePresenter.swift
//  tinkoffChat
//
//  Created by Anton on 19/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ProfilePresenter {
    
    weak var view: ProfileSaveView!
    
    func setSeveData() {
        view.getSaveData()
    }
    
    func loadMainData() {
        view.loadMainData()
    }
    
    func loadReductData() {
        view.loadReductData()
    }
}
