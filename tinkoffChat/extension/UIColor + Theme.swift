//
//  UIColor + Theme.swift
//  tinkoffChat
//
//  Created by Anton on 13/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

extension UIColor {
    static func getTheme() -> UIColor {
        var themeColor = UIColor.white
        let getQueue = DispatchQueue.global(qos: .userInitiated)
        getQueue.async {
            if let colorInt = UserDefaults.standard.object(forKey: "themeColor") as? Int {
                switch colorInt {
                case 1:
                    themeColor = .yellow
                    UINavigationBar.appearance().backgroundColor = .yellow
                case 2:
                    themeColor = .darkGray
                    UINavigationBar.appearance().backgroundColor = .darkGray
                case 3:
                    themeColor = .purple
                    UINavigationBar.appearance().backgroundColor = .purple
                default:
                    themeColor = .white
                    UINavigationBar.appearance().backgroundColor = .white
                }
            }
        }
        return themeColor
    }
    static func setThemeStyle() {
        if let colorInt = UserDefaults.standard.object(forKey: "themeColor") as? Int {
            switch colorInt {
            case 1:
                UINavigationBar.appearance().backgroundColor = .yellow
            case 2:
                UINavigationBar.appearance().backgroundColor = .darkGray
            case 3:
                UINavigationBar.appearance().backgroundColor = .purple
            default:
                UINavigationBar.appearance().backgroundColor = .white
            }
        }
    }
}
