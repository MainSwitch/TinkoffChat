//
//  ThemeService.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol IThemeService {
    func saveTheme(color: UIColor)
    func getSavedTheme() -> UIColor
    func applyTheme(color: UIColor)
    func removeSavedTheme()
}

class ThemeService: IThemeService {
    private var defaults: UserDefaults
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    func saveTheme(color: UIColor) {
        self.defaults.setColor(color: color, forKey: "themeColor")
    }
    func getSavedTheme() -> UIColor {
        return self.defaults.colorForKey(key: "themeColor") ?? UIColor.white
    }
    func applyTheme(color: UIColor) {
        let inverseColor = color.isLight() ? UIColor.black : UIColor.white
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = inverseColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: inverseColor]
    }
    func removeSavedTheme() {
        self.defaults.setColor(color: nil, forKey: "themeColor")
    }
}
