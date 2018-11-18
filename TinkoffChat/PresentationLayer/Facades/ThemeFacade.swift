//
//  ThemeFacade.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol IThemeFacade {
    func saveAndApplyTheme(color: UIColor)
    func retriveAndApplyTheme()
}

class ThemeFacade: IThemeFacade {
    private var themeService: IThemeService
    init(themeService: IThemeService) {
        self.themeService = themeService
    }
    func saveAndApplyTheme(color: UIColor) {
        self.themeService.saveTheme(color: color)
        self.themeService.applyTheme(color: color)
    }
    func retriveAndApplyTheme() {
        self.themeService.applyTheme(color: self.themeService.getSavedTheme())
    }

}
