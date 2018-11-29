//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by rangemotions on 3/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConversationViewController: CommonViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var communicator: ICommunicationFacade?
    var fetchedResultsController: NSFetchedResultsController<Message>?
    var conversationProvider: ConversationDataProvider?
    var conversationId: String?
    var userId: String?
    var online: Bool?
    var userName: String?
    var buttonEnabled: Bool = false {
        didSet {
            // swiftlint:disable all
            UIView.animate(withDuration: 0.5, animations: {
                self.sendButton.isEnabled = self.buttonEnabled
                self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.sendButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
            // swiftlint:enable all
        }
    }
    var userOnline: Bool? {
        didSet {
            guard let online = userOnline else { return }
            let size: CGFloat = online ? 1.1 : 1
            UIView.animate(withDuration: 1) {
                self.titleLabel.transform = CGAffineTransform(scaleX: size, y: size)
            }
            self.titleLabel.textColor = self.userOnline == true ? UIColor.green : UIColor.black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.rootAssembly.presentationAssembly.communicationFacade.setDelegate(delegate: self)
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 66
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.separatorStyle = .none
        guard let conversationId = self.conversationId else { return }
        self.conversationProvider = ConversationDataProvider(tableView: self.tableView, conversationId: conversationId)
        self.fetchedResultsController = self.conversationProvider?.fetchedResultsController
        self.titleLabel.text = self.userName
        self.buttonEnabled = false
        self.userOnline = online
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    @IBAction func sendTouch(_ sender: UIButton) {
        guard let messageText = self.messageTextField.text else {
            return
        }
        self.communicator?.sendMessage(text: messageText, toUser: self.userId!, completion: { (success, _) in
            if success {
                DispatchQueue.main.async {
                    self.messageTextField.text = ""
                    self.buttonEnabled = false
                }
            }
        })
    }
    @IBAction func textFieldDIdChange(_ sender: UITextField) {
        self.buttonEnabled = (self.userOnline ?? false) && (sender.text?.isEmpty == false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.frame.origin = CGPoint(x: (self.navigationController?.navigationBar.frame.size.height)!, y: 0)
        self.tableView.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        AppDelegate.rootAssembly.presentationAssembly.coreDataFacade.updateConversation(conversationId: conversationId)
    }
    @IBAction func tapOnView(_ sender: Any) {
        messageTextField.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant += keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 15
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Data Source
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowsCount = self.fetchedResultsController?.sections?[section].numberOfObjects {
            return rowsCount
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dequeuedCell: MessageTableViewCell
        guard let message = self.fetchedResultsController?.object(at: indexPath) else {
            return UITableViewCell(frame: CGRect.zero)
        }
        if message.isIncoming {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.incomingIdenfitifier, for: indexPath)
            // swiftlint:disable:next force_cast
            dequeuedCell = cell as! MessageTableViewCell
            // swiftlint:disable:previous force_cast
        } else {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.outgoingIdenfitifier, for: indexPath)
            // swiftlint:disable:next force_cast
            dequeuedCell = cell as! MessageTableViewCell
            // swiftlint:disable:previous force_cast
        }
        dequeuedCell.setConfiguration(configuration: message)
        return dequeuedCell
    }
}

// MARK: - CommunicationUserDelegate
extension ConversationViewController: IDisplayUserDelegate {
    func didFoundUser(userID: String, userName: String?) {
        self.buttonEnabled = true
        self.userOnline = true
    }
    func didLostUser(userID: String) {
        self.buttonEnabled = false
        self.userOnline = false
    }
}
