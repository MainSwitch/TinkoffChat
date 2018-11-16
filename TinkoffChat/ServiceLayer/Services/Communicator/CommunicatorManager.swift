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
    func failedToStartBrowsingForUser(error: Error)
    func failedToStartAdvertising(error: Error)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func invitationWasReceived(fromPeer: String)
    func connectedWithPeer(peerID: MCPeerID, session: MCSession)
    func didNotConnect(toPeer: String)
}

protocol ICommunicationManager: class {
    var delegate: IUserFoundDelegate? {get set}
}
