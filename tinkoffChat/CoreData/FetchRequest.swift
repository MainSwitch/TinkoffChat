//
//  FetchRequest.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 09/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class FetchRequest {
    let context: NSManagedObjectContext
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    //var fetchedResultsController: NSFetchedResultsController<Conversation>
    init(managedObjectContext: NSManagedObjectContext) {
        context = managedObjectContext
        //self.fetchedResultsController = fetchedResultsController
    }
    func fetchRequestConversation(with name: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationID == %@ ", name)
        let result = try? context.fetch(request)
        if let result = result {
            result.forEach { $0.printUserName() }
        }
        print("")
        return request
    }
    func fetchNoEmtyOnlineMessage() -> [Message] {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "online == %@ && message != %@", true, "")
        let result = try? context.fetch(request)
        var message = [Message]()
        if let result = result {
            result.forEach {
                message.append($0)
            }
        }
        return message
    }
    func fetchRequestOnile() -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        //request.predicate = NSPredicate(format: "online == %@", "true")
        return request
    }
    func fetchRequestMessage(with name: String) -> Message? {
        var message: Message!
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let result = try? context.fetch(request)
        if let result = result {
            result.forEach({message = $0})
        }
        return message
    }
    func fetchRequestMessage() -> [Message] { //NSFetchRequest<Message> {
        var message = [Message]()
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        let result = try? context.fetch(request)
        if let result = result {
            result.forEach({message.append($0)})
        }
        return message
        //return Message.fetchRequest()
        //request.predicate = NSPredicate(format: "from == %@", userName)
    }
}
