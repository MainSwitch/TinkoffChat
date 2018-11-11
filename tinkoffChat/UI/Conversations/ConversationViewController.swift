//
//  ConversationViewController.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class ConversationViewController: UIViewController, NSFetchedResultsControllerDelegate {

    private var conversationsPresenter = MessageManager.shared.conversationsPresenter
    var tapMessageModel: MessageModel!

    var isSelfSend = false
    var session: MCSession!
    var peer: MCPeerID!
    var messageFrom = [String]()
    var messageText = [MessageTextModel]()
    var lastMessage: MessageModel!
    @IBOutlet var textFieldLayout: NSLayoutConstraint!
    @IBOutlet var sendButtonLayout: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var fetchRequest: FetchRequest!
    private lazy var tableViewDataSource: UITableViewDataSource = {
        let context = appDelegate?.storageManager.coreDataStack.mainContext
            ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let request: NSFetchRequest<Conversation> =
            FetchRequest(managedObjectContext: context).fetchRequestConversation(with: self.title ?? "")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return ConversationTableViewDataSource(fetchedResultsController: fetchedResultsController)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        guard let existAppDelegte = appDelegate else {
            return
        }
        self.fetchRequest = FetchRequest(managedObjectContext: existAppDelegte.storageManager.coreDataStack.mainContext)
        existAppDelegte.communicationManager.conversationViewController = self
        self.session = existAppDelegte.communicationManager.mpcManager.dialogWithPeer.session
        self.peer = existAppDelegte.communicationManager.mpcManager.dialogWithPeer.peerID
        self.conversationsPresenter.conversationView = self
        self.tapMessageModel = self.conversationsPresenter.getChosenModel()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.title = tapMessageModel.name
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        self.conversationsPresenter.loadMessage()
//        if tapMessageModel.message == nil {
//            messageFrom.removeAll()
//            messageText.removeAll()
//        }
        messageTextField.delegate = self
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView(sender:)))
        self.view.addGestureRecognizer(tapOnView)
        if !conversationsPresenter.messageConversation.isEmpty {
            conversationsPresenter.loadMessage()
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textFieldLayout.constant += keyboardSize.height + 5
            self.sendButtonLayout.constant += keyboardSize.height + 5
            //self.view.frame.origin.y -= keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }

        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        //self.view.frame.origin.y = 0
        self.textFieldLayout.constant = 15
        self.sendButtonLayout.constant = 15
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }

    }
    @IBAction func sendAction(_ sender: Any) {
        isSelfSend = true
        guard let existAppDelegte = appDelegate else {
            return
        }
        let messageText = messageTextField.text ?? "nil"
        messageTextField.text = ""
        let userName = existAppDelegte.communicationManager.mpcManager.userName
        lastMessage = MessageModel(conversationID: tapMessageModel.name, name: userName,
                                   message: messageText,
                                   date: Date(), online: true,
                                   hasUnreadMessages: false)
        existAppDelegte.communicationManager.mpcManager.sendSession = self.session
        existAppDelegte.communicationManager.mpcManager.sendMessage(string: messageText,
                                                                    to: peer.displayName) { (succsess, error) in
            if succsess {
                self.messageText.append(MessageTextModel(text: messageText))
                self.messageFrom.append(existAppDelegte.communicationManager.mpcManager.userName)
                existAppDelegte.storageManager.saveDialog(conversationID: self.title ?? "",
                                                          from: userName,
                                                          message: messageText)
                self.tableView.reloadData()
            }
            if error != nil {
                self.showAlertWith(title: "Ошибка отправки сообщения",
                                   message: "Неудалось отправить сообщение :(",
                                   completion: nil)
            }
        }
    }
    @objc func tapOnView(sender: UIViewController) {
        self.view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if lastMessage != nil {
            conversationsPresenter.messageConversation.append(messageText)
            conversationsPresenter.messageConversationFrom.append(messageFrom)
            for (index, model) in conversationsPresenter.messageModelArray.enumerated()
            where model.conversationID == self.title {
                conversationsPresenter.messageModelArray.remove(at: index)
                conversationsPresenter.messageModelArray.insert(lastMessage, at: index)
            }
            guard let existAppDelegate = appDelegate else { return }
            existAppDelegate.storageManager.saveMessageModel(messageModel: lastMessage)
        }
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.sendAction(self)
        return true
    }
}

extension ConversationViewController: ConversationsView {
    func loadMessage(messageConversation: [[MessageTextModel]], messageForm: [[String]]) {
        lastMessage = self.conversationsPresenter.chosenModel
        for (index, model) in conversationsPresenter.messageModelArray.enumerated()
        where model.name == lastMessage.name {
            self.lastMessage = conversationsPresenter.messageModelArray[index]
        }
        var arrayIndex: Int!
        for (index, model) in messageForm.enumerated() {
            for from in model {
                if from == conversationsPresenter.chosenModel.name || lastMessage.name == self.title {
                    arrayIndex = index
                }
            }
        }
        if arrayIndex != nil {
            self.messageText = messageConversation[arrayIndex]
            self.messageFrom = messageForm[arrayIndex]
        }
    }
    func updateUI() {
        self.tableView.reloadData()
    }
}

extension ConversationViewController {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let existAppDelegte = appDelegate else {
//            return UITableViewCell(frame: .zero)
//        }
//        if self.messageFrom[indexPath.row] == existAppDelegte.communicationManager.mpcManager.userName {
//            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "MyMessage",
//                                                             for: indexPath) as? ChatMessageCellIView else {
//                return tableView.dequeueReusableCell(withIdentifier: "MyMessage", for: indexPath)
//            }
//            myCell.myMessage.text = self.messageText[indexPath.row].text
//            return myCell
//        } else {
//            guard let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendMessage",
//                                                                 for: indexPath) as? ChatMessageCellIView else {
//                return tableView.dequeueReusableCell(withIdentifier: "FriendMessage", for: indexPath)
//            }
//            friendCell.friendMessage.text = self.messageText[indexPath.row].text
//            return friendCell
//        }
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messageText.count
//    }
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        print("\(#function)")
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
        tableView.scrollToBottom(animated: true)
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("\(#function)")
        self.tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("\(#function)")
        self.tableView.endUpdates()
    }
}

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
