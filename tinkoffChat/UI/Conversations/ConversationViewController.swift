//
//  ConversationViewController.swift
//  tinkoffChat
//
//  Created by Anton on 05/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController {

    private var conversationsPresenter = MessageManager.shared.conversationsPresenter
    var tapMessageModel: MessageModel!

    var isSelfSeend = false
    var session: MCSession!
    var peer: MCPeerID!
    var messageFrom = [String]()
    var messageText = [MessageTextModel]()
    var lastMessage: MessageModel!
    @IBOutlet var textFieldLayout: NSLayoutConstraint!
    @IBOutlet var sendButtonLayout: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        appDelegate.communicationManager.conversationViewController = self
        self.session = appDelegate.communicationManager.mpcManager.dialogWithPeer.session
        self.peer = appDelegate.communicationManager.mpcManager.dialogWithPeer.peerID
        self.conversationsPresenter.conversationView = self
        self.tapMessageModel = self.conversationsPresenter.getChosenModel()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.title = tapMessageModel.name
        self.conversationsPresenter.loadMessage()
        if tapMessageModel.message == nil {
            messageFrom.removeAll()
            messageText.removeAll()
        }
        messageTextField.delegate = self
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView(sender:)))
        self.view.addGestureRecognizer(tapOnView)
        if !conversationsPresenter.messageConversation.isEmpty {
            conversationsPresenter.loadMessage()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.textFieldLayout.constant += keyboardSize.height + 5
            self.sendButtonLayout.constant += keyboardSize.height + 5
            //self.view.frame.origin.y -= keyboardSize.height
            UIView.animate(withDuration: 0.5){
                self.view.layoutIfNeeded()
            }

        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //self.view.frame.origin.y = 0
        self.textFieldLayout.constant = 15
        self.sendButtonLayout.constant = 15
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func sendAction(_ sender: Any) {
        isSelfSeend = true
        let messageText = messageTextField.text ?? "nil"
        messageTextField.text = ""
        lastMessage = MessageModel(name: self.title, message: messageText, date: Date(), online: true, hasUnreadMessages: false)
        appDelegate.communicationManager.mpcManager.sendSession = self.session
        appDelegate.communicationManager.mpcManager.sendMessage(string: messageText, to: peer.displayName) { (succsess, error) in
            if succsess {
                self.messageText.append(MessageTextModel(text: messageText))
                self.messageFrom.append(self.appDelegate.communicationManager.mpcManager.userName)
                self.tableView.reloadData()
            }
            if (error != nil) {
                self.showAlertWith(title: "Ошибка отправки сообщения", message: "Неудалось отправить сообщение :(", completion: nil)
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
            for (index,model) in conversationsPresenter.messageModelArray.enumerated() {
                if model.name == conversationsPresenter.chosenModel.name {
                    conversationsPresenter.messageModelArray.remove(at: index)
                    conversationsPresenter.messageModelArray.insert(lastMessage, at: index)
                }
            }
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
        var arrayIndex: Int!
        for (index, model) in messageForm.enumerated() {
            for from in model {
                if from == self.title {
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

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messageFrom[indexPath.row] == appDelegate.communicationManager.mpcManager.userName  {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: "MyMessage", for: indexPath) as? ChatMessageCellIView else {
                return tableView.dequeueReusableCell(withIdentifier: "MyMessage", for: indexPath)
            }
            myCell.myMessage.text = self.messageText[indexPath.row].text
            return myCell
        } else {
            guard let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendMessage", for: indexPath) as? ChatMessageCellIView else {
                return tableView.dequeueReusableCell(withIdentifier: "FriendMessage", for: indexPath)
            }
            friendCell.friendMessage.text = self.messageText[indexPath.row].text
            return friendCell
        }
        
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageText.count
    }
}


extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
