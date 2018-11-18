//
//  CommunicatorManager.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol IUserFoundDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
}

protocol ICommunicationManager: class {
    var delegate: IUserFoundDelegate? {get set}
    var displayName: String {get}
    func start()
    func stop()
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func connectedWithPeer(peerID: MCPeerID, session: MCSession)
    func sendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> Void)?)
}

class NewCommunicationManager: NSObject, ICommunicationManager {
    weak var delegate: IUserFoundDelegate?
    private var communicator: ICommunicator
    private var storage: ICommunicatorStorageService
    var displayName: String
    init(storage: ICommunicatorStorageService, communicator: ICommunicator) {
        self.storage = storage
        self.communicator = communicator
        self.displayName = self.communicator.myDisplayName
        super.init()
        self.communicator.delegate = self
    }
    func start() {
        self.communicator.start()
    }
    func stop() {
        self.communicator.stop()
    }
    func didFoundUser(userID: String, userName: String?) {
        self.storage.didFoundUser(userID: userID, userName: userName)
        self.delegate?.didFoundUser(userID: userID, userName: userName)
    }
    func didLostUser(userID: String) {
        self.storage.didLostUser(userID: userID)
        self.delegate?.didLostUser(userID: userID)
    }
    func failedToStartBrowsingForUsers(error: Error) {
        // Ignore
    }
    func failedToStartAdvertising(error: Error) {
        // Ignore
    }
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.storage.recieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    func sendMessage(text: String,
                     toUser: String,
                     completion: ((Bool, Error?) -> Void)?) {
        self.storage.recieveMessage(text: text, fromUser: communicator.myDisplayName, toUser: toUser)
        self.communicator.sendMessage(string: text, to: toUser, completionHandler: completion)
    }
    func connectedWithPeer(peerID: MCPeerID, session: MCSession) {
        print("--->>>>>")
    }
}
