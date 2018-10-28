//
//  CommunicationManager.swift
//  tinkoffChat
//
//  Created by Anton on 26/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct FoundPeer {
    let peerID: MCPeerID
    let userName: String
    let session: MCSession
}

struct FoundUser {
    let userID: String
    let userName: String
}

class CommunicationManager: CommunicationDelegate {
    
    weak var conversationsListViewController: ConversationsListViewController!
    weak var conversationViewController: ConversationViewController!
    private var conversationsPresenter = MessageManager.shared.conversationsPresenter
    
    var mpcManager: MultipeerCommunicator!
    var connectedPeer = [FoundPeer]()
    var foundUser = [FoundUser]()
    
    var isAdvertising: Bool!
    
    init(view: UIViewController) {
        if let view = view as? ConversationsListViewController {
            self.conversationsListViewController = view
        } else if let view = view as? ConversationViewController {
            self.conversationViewController = view
        }
        mpcManager = MultipeerCommunicator()
    }
    
    func startBrowsingAndAdvertising() {
        mpcManager.delegate = self
        //manager.mpcManager.delegate = self
        mpcManager.browser.startBrowsingForPeers()
        mpcManager.advertiser.startAdvertisingPeer()
        isAdvertising = true
    }
    
    func didFoundUser(userID: String, userName: String?) {
        //let newMcpManager = MultipeerCommunicator()
        foundUser.append((FoundUser(userID: userID, userName: userName ?? "unknown")))
        conversationsPresenter.foundUser()
        conversationsListViewController.tableView.reloadData()
        
    }
    
    func didLostUser(userID: String) {
        for (index, user) in foundUser.enumerated() {
            if user.userID == userID {
                for (index, model) in connectedPeer.enumerated() {
                    if model.peerID.displayName == userID {
                        connectedPeer.remove(at: index)
                    }
                }
                foundUser.remove(at: index)
            }
        }
        if conversationViewController != nil {
            conversationViewController.sendButton.isEnabled = false
        }
        conversationsListViewController.tableView.reloadData()
    }
    
    func failedToStartBrowsingForUser(error: Error) {
        conversationsListViewController.showAlertWith(title: "Failed to start browsing for user", message: "попробуйте перезагрузить приложение", completion: nil)
    }
    
    func failedToStartAdvertising(error: Error) {
        conversationsListViewController.showAlertWith(title: "failed to start advertising", message: "попробуйте перезагрузить приложение", completion: nil)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if conversationViewController != nil {
            conversationViewController.messageFrom.append(fromUser)
            conversationViewController.messageText.append(MessageTextModel(text: text))
            conversationViewController.lastMessage = MessageModel(name: fromUser, message: text, date: Date(), online: true, hasUnreadMessages: false)
            DispatchQueue.main.async {
                self.conversationViewController.tableView.reloadData()
            }
        } else {
            var countAdd = 0
            for (index,model) in conversationsPresenter.messageModelArray.enumerated() {
                if model.name == conversationsPresenter.chosenModel.name {
                    conversationsPresenter.messageModelArray.remove(at: index)
                    for (index, model) in conversationsPresenter.messageConversationFrom.enumerated() {
                        for from in model {
                            if from == conversationsPresenter.chosenModel.name && countAdd == 0 {
                            conversationsPresenter.messageConversationFrom[index].append(fromUser)
                            conversationsPresenter.messageConversation[index].append(MessageTextModel(text: text))
                            conversationsPresenter.lastMessageArray.append(MessageModel(name: from, message: text, date: Date(), online: true, hasUnreadMessages: true))
                                countAdd = 1
                            }
                        }
                    }
                    conversationsPresenter.messageModelArray.insert(MessageModel(name: fromUser, message: text, date: Date(), online: true, hasUnreadMessages: true), at: index)
                    DispatchQueue.main.async {
                        self.conversationsListViewController.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertController.Style.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            if let navigation = self.conversationsListViewController.navigationController {
                navigation.popToRootViewController(animated: true)
            }
            self.mpcManager.invitationHandler(true, self.mpcManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
            self.mpcManager.invitationHandler(false, nil)
            self.didNotConnect(toPeer: fromPeer)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.conversationsListViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID, session: MCSession) {
        var name: String {
            var string: String!
            for user in foundUser {
                if user.userID == peerID.displayName {
                    string = user.userName
                }
            }
            if conversationViewController != nil {
                if peerID.displayName == conversationViewController.title{
                    DispatchQueue.main.async {
                        self.conversationViewController.sendButton.isEnabled = true
                    }
                }
            }
            conversationsPresenter.choseModel(model: MessageModel(name: string, message: nil, date: nil, online: true, hasUnreadMessages: false))
            return string
        }
        OperationQueue.main.addOperation {
            self.mpcManager.dialogWithPeer = FoundPeer(peerID: peerID, userName: name, session: session)
            self.conversationsListViewController.performSegue(withIdentifier: "idSegueChat", sender: self)
            self.conversationsListViewController.tableView.reloadData()
        }
        
        var notContain = true
        for conectedModel in connectedPeer {
            if conectedModel.peerID == peerID {
                notContain = false
            }
        }
        if notContain {
            connectedPeer.append(FoundPeer(peerID: peerID, userName: name, session: session))
        }
    }
    
    func didNotConnect(toPeer: String) {
        var notContain = true
        var removeIndex: Int!
        for (index,conectedModel) in connectedPeer.enumerated() {
            if conectedModel.peerID.displayName == toPeer {
                notContain = false
                removeIndex = index
            }
        }
        if !notContain {
            self.connectedPeer.remove(at: removeIndex)
        }
    }
}
