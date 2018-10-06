//
//  ChatLabel.swift
//  tinkoffChat
//
//  Created by Anton on 06/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

@IBDesignable
class ChatLabel: UILabel {
    
    @IBInspectable var isMyMassage: Bool = true {
        didSet {
            setUI()
        }
    }
    
    func setUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 4
        self.backgroundColor = isMyMassage ? UIColor.blue.withAlphaComponent(0.3) : UIColor.green.withAlphaComponent(0.3)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
 

}
