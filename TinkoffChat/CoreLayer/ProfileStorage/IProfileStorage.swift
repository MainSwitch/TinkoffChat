//
//  IProfileStorage.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol IProfileStorage {
    var coreDataStack: ICoreDataStack { get }
    func save(name: String?, about: String?, image: Data?)
    func fetchProfile(key: String) -> UIImage?
}
