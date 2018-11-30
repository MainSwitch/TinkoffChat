//
//  ThemeVC.swift
//  tinkoffChat
//
//  Created by Anton on 17/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class Themes {
    var theme1: UIColor
    var theme2: UIColor
    var theme3: UIColor
    init() {
        self.theme1 = UIColor.orange.withAlphaComponent(0.6)
        self.theme2 = UIColor.gray.withAlphaComponent(0.6)
        self.theme3 = UIColor.purple.withAlphaComponent(0.6)
    }
    func setTheme1(theme1: UIColor) {
        self.theme1 = theme1
    }
    func setTheme2(theme2: UIColor) {
        self.theme2 = theme2
    }
    func setTheme3(theme3: UIColor) {
        self.theme3 = theme3
    }
}

class ThemeVC: CommonViewController {
    weak var delegate: ThemesViewControllerDelegate?
    var model: Themes?
    func setDeleagete(delegate: ThemesViewControllerDelegate) {
        self.delegate = delegate
    }
    func setModel(model: Themes) {
        self.model = model
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Тема"
        let decodedData = UserDefaults.standard.object(forKey: "selectedColor") as? Data
        if let data = decodedData {
            let selectedColor = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
            self.view.backgroundColor = selectedColor
        }
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancelAction))
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    @IBAction func setTheme(_ sender: Any) {
        let themeButton = sender as? UIButton
        if themeButton == nil {
            return
        }
        if model == nil {
            model = Themes()
        }
        var selectedColor: UIColor?
        switch themeButton?.tag {
        case 1:
            selectedColor = model?.theme1
        case 2:
            selectedColor = model?.theme2
        default:
            selectedColor = model?.theme3
        }
        view.backgroundColor = selectedColor
        delegate?.themesViewController(controller: self, selectedTheme: selectedColor ?? .yellow)
    }
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension ThemeVC: ThemesViewControllerDelegate {
    func themesViewController(controller: ThemeVC, selectedTheme: UIColor) {
        self.delegate = controller
    }
}
