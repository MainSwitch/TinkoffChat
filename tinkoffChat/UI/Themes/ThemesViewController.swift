//
//  ThemesViewController.swift
//  tinkoffChat
//
//  Created by Anton on 13/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    var conversationListView: ConversationsListViewController!
    private let userDefaults = UserDefaults.standard
    
    var themeLightBtn: UIButton!
    var themeDarckBtn: UIButton!
    var shampayneBtn: UIButton!
    let saveQueue = DispatchQueue.global(qos: .utility)
    
    enum Position: Int {
        case first = 3
        case second
        case third
    }
    
    var setThemeClosure = { (controller: ThemesViewController, color: UIColor, colorClosure: ()->()) in
        colorClosure()
        controller.view.backgroundColor = color
        UINavigationBar.appearance().backgroundColor = color
        controller.navigationController?.navigationBar.backgroundColor = color
    }
    
    @objc func dissmisVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func lightThemeButton(_ sender: Any) {
        if let btnColor = themeLightBtn.backgroundColor {
            setThemeClosure(self, btnColor) {
                saveQueue.async {
                    self.userDefaults.set(1, forKey: "themeColor")
                }
            }
            
        }
    }
    
    @objc func darkThemeButton(_ sender: Any) {
        if let btnColor = themeDarckBtn.backgroundColor {
            setThemeClosure(self, btnColor) {
                saveQueue.async {
                    self.userDefaults.set(2, forKey: "themeColor")
                }
            }
        }
    }
    
    @objc func shapayneThemeButtom(_ sender: Any) {
        if let btnColor = shampayneBtn.backgroundColor {
            setThemeClosure(self, btnColor) {
                saveQueue.async {
                    self.userDefaults.set(3, forKey: "themeColor")
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.view.backgroundColor = UIColor.getTheme()
    }
    
    func setupUI() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dissmisVC))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        themeLightBtn = UIButton()
        themeLightBtn.addTarget(self, action: #selector(lightThemeButton(_:)), for: .touchUpInside)
        setButton(button: themeLightBtn, title: "Светлая", position: .first, bgColor: .yellow)
        
        themeDarckBtn = UIButton()
        themeDarckBtn.addTarget(self, action: #selector(darkThemeButton(_:)), for: .touchUpInside)
        setButton(button: themeDarckBtn, title: "Тёмная", position: .second, bgColor: .darkGray)
        
        shampayneBtn = UIButton()
        shampayneBtn.addTarget(self, action: #selector(shapayneThemeButtom(_:)), for: .touchUpInside)
        setButton(button: shampayneBtn, title: "Шампейн", position: .third, bgColor: .purple)
        
    }
    func setButton(button: UIButton,title: String, position: Position, bgColor: UIColor) {
        let multiplayPosition = CGFloat(position.rawValue)
        if let view = self.view {
            button.setTitleColor(.black, for: .normal)
            button.setTitle(title, for: .normal)
            button.backgroundColor = bgColor
            button.bounds = CGRect(x: 0, y: 0, width: 144, height: 44)
            button.center = CGPoint(x: view.center.x, y: view.frame.height/8 * multiplayPosition)
            self.view.addSubview(button)
        }
    }
    
}
