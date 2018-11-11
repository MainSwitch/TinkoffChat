//
//  ConversationsPresenter.swift
//  tinkoffChat
//
//  Created by Anton on 04/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class ConversationsPresenter {
    var messageModelArray: [MessageModel] = [MessageModel]()
    var messageConversation: [[MessageTextModel]] = [[MessageTextModel]()]
    var messageConversationFrom: [[String]] = [[String]()]
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    var chosenModel: MessageModel!
    //var message: [MessageModel]!

    weak var conversationListView: ConversationsListView!
    weak var conversationView: ConversationsView!
    func loadDialog() {
        guard let existAppDelegate = appDelegate else {
            return
        }
        if existAppDelegate.communicationManager.foundUser.isEmpty {
            messageModelArray = []
        }
    }
    func foundUser() {
        guard let existAppDelegate = appDelegate else {
            return
        }
        for user in existAppDelegate.communicationManager.foundUser {
            for (index, model) in messageModelArray.enumerated()
            where model.name == user.userName {
                messageModelArray.remove(at: index)
                break
            }
            let message = FetchRequest(managedObjectContext: existAppDelegate.storageManager.coreDataStack.mainContext)
            .fetchRequestMessage(with: user.userName)
            let messageModel = MessageModel(conversationID: user.userName,
                                            name: message?.name ?? user.userName,
                                            message: message?.message ?? nil,
                                            date: message?.date ?? nil,
                                            online: message?.online ?? true,
                                            hasUnreadMessages: message?.hasUnreadMessages ?? false)
            existAppDelegate.storageManager.saveMessageModel(messageModel: messageModel)
            messageModelArray.append(messageModel)
//            print(message.forEach({$0.name}))
        }
    }
    func loadMessage() {
        self.conversationView.loadMessage(messageConversation: messageConversation,
                                          messageForm: messageConversationFrom)
    }
    func choseModel(model: MessageModel?) {
        if let existModel = model {
            self.chosenModel = existModel
        }
    }
    func getChosenModel() -> MessageModel {
        if let existModel = self.chosenModel {
            return existModel
        } else {
            return MessageModel(conversationID: "",
                                name: nil,
                                message: nil,
                                date: nil,
                                online: true,
                                hasUnreadMessages: false)
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
