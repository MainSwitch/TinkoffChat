//
//  ChatMessageCellIView.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ChatMessageCellIView: UITableViewCell, MessageCellConfiguration {
    
    var textMessage: String?

    @IBOutlet weak var myMessage: UILabel!
    @IBOutlet weak var friendMessage: UILabel!
    
    func setupUI() {
        textMessage = ""
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}