//
//  ThemesViewController.swift
//  tinkoffChat
//
//  Created by Anton on 13/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    var conversationListView: ConversationsListViewController!
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var themeLightBtn: UIButton!
    @IBOutlet weak var themeDarckBtn: UIButton!
    @IBOutlet weak var shampayneBtn: UIButton!
    
    var setThemeClosure = { (controller: ThemesViewControllerSwift, color: UIColor, colorClosure: ()->()) in
        controller.view.backgroundColor = color
        controller.conversationListView.logThemeChanging(selectedTheme: color)
        UINavigationBar.appearance().backgroundColor = color
        controller.navigationController?.navigationBar.backgroundColor = color
        colorClosure()
    }
    
    @IBAction func LightThemeButton(_ sender: Any) {
        if let btnColor = themeLightBtn.backgroundColor {
            setThemeClosure(self, btnColor) {
                userDefaults.set(1, forKey: "themeColor")
            }
            
        }
    }
    @IBAction func DarkThemeButton(_ sender: Any) {
        if let btnColor = themeDarckBtn.backgroundColor {
            setThemeClosure(self, btnColor) {
                userDefaults.set(2, forKey: "themeColor")
            }
        }
    }
    @IBAction func ShapayneThemeButtom(_ sender: Any) {
        if let btnColor = shampayneBtn.backgroundColor {
            setThemeClosure(self, btnColor) {
                userDefaults.set(3, forKey: "themeColor")
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversationListView = ConversationsListViewController()
        self.view.backgroundColor = UIColor.getTheme()
        themeLightBtn.backgroundColor = UIColor.yellow
        themeDarckBtn.backgroundColor = UIColor.darkGray
        shampayneBtn.backgroundColor = UIColor.purple
    }
}
