//
//  CommunicatorStorageService.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol ICommunicatorStorageService {
    var connectedPeer: [FoundPeer] { get set }
    var foundUser: [FoundUser] { get set }
    var isAdvertising: Bool! { get set}
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
    func invitationWasReceived(fromPeer: String) {
    
}

class CommunicatorStorageService: ICommunicatorStorageService {
    var connectedPeer = [FoundPeer]()
    var foundUser = [FoundUser]()
    var isAdvertising: Bool!
    private var dataStack: ICoreDataStack
    private var communicator: ICommunicator
    init(dataStack: ICoreDataStack, communicator: ICommunicator) {
        self.dataStack = dataStack
        self.communicator = communicator
    }
    

}
