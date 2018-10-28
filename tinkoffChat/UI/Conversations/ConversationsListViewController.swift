//
//  ViewController.swift
//  tinkoffChat
//
//  Created by Anton on 03/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {
    
    var messageModel: [[MessageModel]]!
    
    var conversationsPresenter =  MessageManager.shared.conversationsPresenter

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func themesAction(_ sender: Any) {
        let vc = ThemesViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    @IBAction func profileAction(_ sender: Any) {
        let storyboard = MessageManager.shared.profileStoryboard
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as UIViewController
        let navigationVC = UINavigationController(rootViewController: vc)
        self.present(navigationVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.conversationsPresenter.conversationListView = self
        appDelegate.communicationManager = CommunicationManager(view: self)
        appDelegate.communicationManager.startBrowsingAndAdvertising()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}

extension ConversationsListViewController: ConversationsListView {
    
    func updateUI() {
        self.tableView.reloadData()
    }
    
    func updateData(model: [[MessageModel]]?) {
        if let modelArray = model {
            self.messageModel = modelArray
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageModel[section].count
        //return appDelegate.mpcManager.foundPeers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellView", for: indexPath) as? MessageCellView else {
            return tableView.dequeueReusableCell(withIdentifier: "MessageCellView", for: indexPath)
        }
        let sectionMessageModel = messageModel[indexPath.section][indexPath.row]

        cell.name = sectionMessageModel.name
        cell.online = sectionMessageModel.online
        cell.date = sectionMessageModel.date
        cell.hasUnreadMessages = sectionMessageModel.hasUnreadMessages
        cell.message = sectionMessageModel.message
        cell.setupUI()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return messageModel.count
        self.conversationsPresenter.updateConversationsList()
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "None"
        }
    }
}


extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = messageModel[indexPath.section][indexPath.row]
        self.conversationsPresenter.choseModel(model: model)
        var peerDontConnect = true
        var connectedPeerIndex: Int!
        for (index,conectedModel) in appDelegate.communicationManager.connectedPeer.enumerated() {
            if conectedModel.peerID == appDelegate.communicationManager.mpcManager.foundPeers[indexPath.row] {
                peerDontConnect = false
                connectedPeerIndex = index
            }
        }
        if peerDontConnect {
            let newPeerSession = MCSession(peer: appDelegate.communicationManager.mpcManager.peer)
            let conectedPeer = appDelegate.communicationManager.mpcManager.foundPeers[indexPath.row]
            newPeerSession.delegate = appDelegate.communicationManager.mpcManager
            appDelegate.communicationManager.connectedPeer.append(FoundPeer(peerID: conectedPeer, userName: appDelegate.communicationManager.foundUser[indexPath.row].userName, session: newPeerSession))
            appDelegate.communicationManager.mpcManager.browser.invitePeer(conectedPeer, to: newPeerSession, withContext: nil, timeout: 10)
        } else {
            appDelegate.communicationManager.connectedWithPeer(peerID: appDelegate.communicationManager.connectedPeer[connectedPeerIndex].peerID, session: appDelegate.communicationManager.connectedPeer[connectedPeerIndex].session)
        }
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}

