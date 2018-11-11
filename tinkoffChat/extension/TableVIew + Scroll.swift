//
//  TableVIew + Scroll.swift
//  tinkoffChat
//
//  Created by Anton on 11/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let yPosition = contentSize.height - frame.size.height + 44
        setContentOffset(CGPoint(x: 0, y: (yPosition < 0) ? 0 : yPosition), animated: animated)
    }
}
