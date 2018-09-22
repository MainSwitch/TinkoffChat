//
//  UIApplicationState + String.swift
//  tinkoffChat
//
//  Created by Anton on 21.09.2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

extension UIApplication.State {
    func descriptionString() -> String{
        switch self {
        case .active:
            return "active"
        case .background:
            return "background"
        case .inactive:
            return "inactive"
        }
    }
}
