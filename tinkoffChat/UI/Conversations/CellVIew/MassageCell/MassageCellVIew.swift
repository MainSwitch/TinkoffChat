//
//  MessageCell.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class MessageCellView: UITableViewCell, ConversationCellConfiguration {
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var chatDate: UILabel!
    var name: String? {
        didSet {
            self.chatName.textColor = name != nil ? UIColor.black : UIColor.red
            chatName.text = name ?? "unknown"
        }
    }
    var message: String? {
        didSet {
            if message == nil {
                lastMessage.font = UIFont(name: "AvenirNext-Medium", size: 13)
                lastMessage.text = "No messages yet"
                message = "No messages yet"
            } else {
                lastMessage.font = UIFont.systemFont(ofSize: 17)
                lastMessage.text = message
            }
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
    var hasUnreadMessages: Bool = false {
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
        if hasUnreadMessages {
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold(message ?? "")
            self.lastMessage.attributedText = formattedString
        } else {
            self.lastMessage.text = message
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
