//
//  OutgoingTableViewCell.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewCell: UITableViewCell {
    static let incomingIdenfitifier: String = "Incoming"
    static let outgoingIdenfitifier: String = "Outgoing"
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    var configuration: Message?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.bubbleView.layer.cornerRadius = 14
        self.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
    }
    func setConfiguration(configuration: Message) {
        self.configuration = configuration
        self.messageLabel.text = configuration.text
        if configuration.isIncoming {
//            self.bubbleView.backgroundColor = UIColor.init(red: 0.33, green: 0.94, blue: 0.77, alpha: 1.0)
            //self.changeImage(name: "bubble_received")
        } else {
//            self.bubbleView.backgroundColor = UIColor.init(red: 0.45, green: 0.73, blue: 1.0, alpha: 1.0)
//            self.changeImage(name: "bubble_sent")
        }
        //self.bubbleImageView.tintColor = self.bubbleView.backgroundColor
    }
//    func changeImage(name: String) {
//        guard let image = UIImage(named: name) else { return }
////        self.bubbleImageView.image =
////            image.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14),
////                                 resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
//    }
}
