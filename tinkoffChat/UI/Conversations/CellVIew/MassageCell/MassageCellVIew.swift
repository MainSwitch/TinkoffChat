//
//  MassageCell.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class MassageCellView: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var lastMassage: UILabel!
    @IBOutlet weak var chatDate: UILabel!
    
    var name: String? {
        didSet {
            self.chatName.textColor = name != nil ? UIColor.black : UIColor.red
            chatName.text = name ?? "unknown"
        }
    }
    var massage: String? {
        didSet {
            lastMassage.text = massage
        }
    }
    var date: Date? {
        didSet {
            self.chatDate.text = date?.toString() ?? "none"
            chatDate.text = date?.toString()
        }
    }
    var online: Bool = false {
        didSet {
            setupUI()
        }
    }
    var hasUnreadMassages: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    func setupUI() {
        if online {
            self.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        } else {
            self.backgroundColor = UIColor.white
        }
        
        if hasUnreadMassages {
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold(massage ?? " ")
            self.lastMassage.attributedText = formattedString
        } else {
            self.lastMassage.text = massage
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

