//
//  MessageTableViewDataSource.swift
//  tinkoffChat
//
//  Created by Anton on 11/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class MessageTableViewDataSource: NSObject, UITableViewDataSource {
    let fetchedResultsController: NSFetchedResultsController<Message>
    private var cellIdentifier = "MessageCellView"
    init(fetchedResultsController: NSFetchedResultsController<Message>) {
        self.fetchedResultsController = fetchedResultsController
        try? fetchedResultsController.performFetch()
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let message = self.fetchedResultsController.object(at: indexPath)
            var cell: MessageCellView = MessageCellView(frame: .zero)
                cellIdentifier = "MessageCellView"
            if let newCell =
                tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? MessageCellView {
                newCell.name = message.name
                newCell.online = message.online
                newCell.date = message.date
                newCell.hasUnreadMessages = message.hasUnreadMessages
                newCell.message = message.message
                newCell.setupUI()
                cell = newCell
            } else {
                assertionFailure("Cell with id \(self.cellIdentifier) not exists")
                return UITableViewCell()
            }
            // Configure the cell with data from the managed object.
            return cell
    }
}
