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
    
    var name: String?
    var massage: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMassages: Bool = false
    
    func setupUI() {
        self.chatName.text = name ?? "unknown"
        self.chatName.textColor = name != nil ? UIColor.black : UIColor.red
        self.chatDate.text = date?.toString() ?? "none"
        print("name: \(String(describing: name)), isOnline: \(online)")
        if online {
            self.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        } else {
            self.backgroundColor = UIColor.white
        }
        self.lastMassage.textColor = massage != nil ? UIColor.black : UIColor.darkGray
        if hasUnreadMassages {
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold(massage ?? " ")
            self.lastMassage.attributedText = formattedString
        } else {
            self.lastMassage.text = massage ?? "Now there are no messages"
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

