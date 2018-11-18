//
//  ThemeViewControllerDelegate.swift
//  tinkoffChat
//
//  Created by Anton on 17/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol ThemesViewControllerDelegate: class {
    func themesViewController(controller: ThemeVC, selectedTheme: UIColor)
}
