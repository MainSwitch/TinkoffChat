//
//  StateSingleton.swift
//  tinkoffChat
//
//  Created by Anton on 21.09.2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class StateSingleton {
    
    static let shared = StateSingleton()
    
    private init() {}
    
    var applicationState: String?
    var viewState: String?
}
