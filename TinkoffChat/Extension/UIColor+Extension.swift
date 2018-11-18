//
//  UIColor+Extension.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIColor {
    func isLight() -> Bool {
        let components = self.cgColor.components
        if let componentsUnwrapped = components {
            if componentsUnwrapped.count > 2 {
                let brightness = ((components![0] * 299) + (components![1] * 587) + (components![2] * 114)) / 1000
                return brightness >= 0.5
            }
        }
        return true
    }
}
