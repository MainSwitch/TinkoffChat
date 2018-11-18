//
//  Conversation+CoreData.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    static func insertConversation(with conversationId: String,
                                   in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation",
                                                                  into: context) as? Conversation {
            conversation.conversationId = conversationId
            return conversation
        }
        return nil
    }
    static func findOrInsertConversation(with conversationId: String,
                                         in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = Conversation.findConversation(with: conversationId, in: context) {
            return conversation
        } else {
            return Conversation.insertConversation(with: conversationId, in: context)
        }
    }
    static func findConversation(with conversationId: String, in context: NSManagedObjectContext) -> Conversation? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        var conversation: Conversation?
        guard let fetchRequest = Conversation.fetchRequestConversation(with: conversationId, model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Conversations found!")
            if let foundConversation = results.first {
                conversation = foundConversation
            }
        } catch {
            print ("Failed to fetch conversation: \(error)")
        }
        return conversation
    }
    static func fetchRequestConversation(with conversationId: String,
                                         model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationById"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName,
                                                                substitutionVariables:
            ["conversationId": conversationId]) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
}
