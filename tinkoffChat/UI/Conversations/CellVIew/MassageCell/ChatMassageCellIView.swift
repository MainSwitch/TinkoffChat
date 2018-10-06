//
//  ChatMassageCellIView.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ChatMassageCellIView: UITableViewCell, MassageCellConfiguration {
    
    var textMassage: String?

    @IBOutlet weak var myMassage: UILabel!
    @IBOutlet weak var friendMassage: UILabel!
    
    func setupUI() {
        textMassage = ""
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
