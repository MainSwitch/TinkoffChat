//
//  ConversationsPresenter.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ConversationsPresenter {
    
    var messageModelArray: [MessageModel] = [MessageModel]()
    var messageConversation: [[MessageTextModel]] = [[MessageTextModel]()]
    var messageConversationFrom: [[String]] = [[String]()]
    var lastMessageArray = [MessageModel]()

    var chosenModel: MessageModel!
    //var message: [MessageModel]!

    
    weak var conversationListView: ConversationsListView!
    weak var conversationView: ConversationsView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //этот метод я не выпилил так как не успеваю
    func loadDialog() {
        if appDelegate.communicationManager.foundUser.isEmpty {
            messageModelArray = []
        }
//        messageModelArray.append(MessageModel(name: "Anton", message: "Hello!", date: Date(), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Misha", message: "Yes, alright", date: Date(timeIntervalSinceReferenceDate: -100), online: true, hasUnreadMessages: true))
//        messageModelArray.append(MessageModel(name: "Edgar", message: "How are you?", date: Date(timeIntervalSinceNow: -1231556), online: true, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Vitya", message: "What are you doing in Tinkoff?", date: Date(timeIntervalSinceNow: -1234), online: false, hasUnreadMessages: true))
//        messageModelArray.append(MessageModel(name: "Davit", message: "Soon", date: Date(timeIntervalSinceNow: -1000), online: false, hasUnreadMessages: true))
//        messageModelArray.append(MessageModel(name: "SomeGuy", message: "Hello)))))))", date: Date(timeIntervalSinceNow: -1231251125), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Mom", message: "Where are you ??????????", date: Date(), online: true, hasUnreadMessages: true))
//        messageModelArray.append(MessageModel(name: "Dady", message: "You're in deep trouble!!!!!", date: Date(), online: true, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Donald Duck", message: "QUACK", date: Date(timeIntervalSinceNow: -234), online: true, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "DONALD TRUMP", message: "WE MAKE THE WALL", date: Date(timeIntervalSinceNow: -1345), online: true, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Steve Jobs", message: nil, date: nil, online: true, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "BATMAN", message: "where the detonator?????", date: Date(timeIntervalSinceNow: -71), online: true, hasUnreadMessages: true))
//        messageModelArray.append(MessageModel(name: "Flash", message: "I'm soo fast bro", date: Date(), online: true, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Brother", message: "ok, let's go..", date: Date(timeIntervalSinceNow: -179), online: true, hasUnreadMessages: true))
//        messageModelArray.append(MessageModel(name: nil, message: "You kown?", date: Date(timeIntervalSinceNow: -320), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Tinkoff", message: "You'r cool!", date: Date(timeIntervalSinceNow: -720), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Mask", message: "this rocket is really fast", date: Date(timeIntervalSinceNow: -13215), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Tony Stark", message: "hi mechanic!!", date: Date(timeIntervalSinceNow: -5235), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Thor", message: "will you come?", date: Date(timeIntervalSinceNow: -1421355), online: false, hasUnreadMessages: false))
//        messageModelArray.append(MessageModel(name: "Bro", message: nil, date: Date(timeIntervalSinceNow: -1421355), online: false, hasUnreadMessages: false))
    }
    
    func foundUser() {
        for user in appDelegate.communicationManager.foundUser {
            for (index, model) in messageModelArray.enumerated() {
                if model.name == user.userName {
                    messageModelArray.remove(at: index)
                    break
                }
            }
            messageModelArray.append(MessageModel(name: user.userName, message: nil, date: nil, online: true, hasUnreadMessages: false))
        }
    }
    
    func loadMessage() {
        self.conversationView.loadMessage(messageConversation: messageConversation, messageForm: messageConversationFrom)
    }
    
    func choseModel(model: MessageModel?){
        if let existModel = model {
            self.chosenModel = existModel
        }
    }
    
    func getChosenModel() -> MessageModel {
        if let existModel = self.chosenModel {
            return existModel
        } else {
            return MessageModel(name: nil, message: nil, date: nil, online: false, hasUnreadMessages: false)
        }
    }
    
    func updateConversationsList() {
        loadDialog()
        var sortMessageModel = [[MessageModel]]()
        sortMessageModel.append(messageModelArray.filter { $0.online }.sorted(by: { (first, second) -> Bool in
            if let firstDate = first.date {
                if let secondDate = second.date {
                    return firstDate > secondDate
                }
            }
            return false
        }))
        
        sortMessageModel.append(messageModelArray.filter { $0.online == false}.sorted(by: { (first, second) -> Bool in
            if let firstDate = first.date {
                if let secondDate = second.date {
                    return firstDate > secondDate
                }
            }
            return false
        }))
        
        
        
        self.conversationListView.updateData(model: sortMessageModel)
    }
    
    
}
