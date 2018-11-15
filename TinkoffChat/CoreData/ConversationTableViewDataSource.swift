//
//  TableViewDataSource.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 09/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class ConversationTableViewDataSource: NSObject, UITableViewDataSource {
    let fetchedResultsController: NSFetchedResultsController<Conversation>
    private var cellIdentifier = "MyMessage"

    init(fetchedResultsController: NSFetchedResultsController<Conversation>) {
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
        let dialog = self.fetchedResultsController.object(at: indexPath)
        let userName = UserDefaults.standard.string(forKey: "name") ?? UIDevice.current.name
            var cell: ChatMessageCellIView = ChatMessageCellIView(frame: .zero)
        if userName == dialog.from {
            cellIdentifier = "MyMessage"
            if let newCell =
                tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? ChatMessageCellIView {
                newCell.myMessage.text = dialog.message
                cell = newCell
            } else {
                assertionFailure("Cell with id \(self.cellIdentifier) not exists")
                return UITableViewCell()
            }
        } else {
            cellIdentifier = "FriendMessage"
            if let newCell =
                tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? ChatMessageCellIView {
                newCell.friendMessage.text = dialog.message
                cell = newCell
            } else {
                assertionFailure("Cell with id \(self.cellIdentifier) not exists")
                return UITableViewCell()
            }
        }
        // Configure the cell with data from the managed object.
        return cell
    }
}