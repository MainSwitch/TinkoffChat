//
//  CoreDataFacade.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataFacade {
    var mainContext: NSManagedObjectContext {get}
    func updateConversation(conversationId: String?)
}

class CoreDataFacade: ICoreDataFacade {
    private var coreData: ICoreDataService
    var mainContext: NSManagedObjectContext { return self.coreData.mainContext }
    init(coreData: ICoreDataService) {
        self.coreData = coreData
    }
    func updateConversation(conversationId: String?) {
        guard let conversationIdUnwrapped = conversationId else {
            return
        }
        let convers = Conversation.findConversation(with: conversationIdUnwrapped, in: self.coreData.saveContext)
        convers?.lastMessage?.isUnread = false
        self.coreData.performSave(context: self.coreData.saveContext, completionHandler: nil)
    }
}
