//
//  StorageManager.swift
//  tinkoffChat
//
//  Created by Anton on 01/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class StorageManager {
    var coreDataStack: CoreDataStack!
//    var managedObjectModel: NSManagedObjectModel!
//    var persistentStoreCoordinator: NSPersistentStoreCoordinator!
//    var masterContext: NSManagedObjectContext!
//    var mainContext: NSManagedObjectContext!
    var saveContext: NSManagedObjectContext!
    init() {
        coreDataStack = CoreDataStack()
        saveContext = coreDataStack.saveContext
    }
    typealias SaveCompletion = () -> Void
    func saveProfileData(name: String?,
                         about: String?,
                         image: Data?) {
//        var context: [NSManagedObjectContext] = [coreDataStack.saveContext]
//                if let parentContext = saveContext.parent {
//                    context.append(parentContext)
//                    if let parent = parentContext.parent {
//                        context.append(parent)
//                    }
//                }
//        for context in context {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
//        do {
//            let results = try context.fetch(request)
//            if results.count > 0 {
//                for person in results as! [NSManagedObject] {
//                    if let userName = person.value(forKey: "name") {
//                        if userName as? String ==
//                            StorageManager.findOrInsertAppUser(in: coreDataStack.mainContext)?.name {
//                            person.setValue(name, forKeyPath: "name")
//                            person.setValue(about, forKeyPath: "about")
//                        }
//                    }  else {
//                        let entity = NSEntityDescription.entity(forEntityName: "AppUser", in: context)!
//                        let person = NSManagedObject(entity: entity, insertInto: context)
//                        person.setValue(name, forKeyPath: "name")
//                        person.setValue(about, forKeyPath: "about")
//                    }
//                }
//            }
//        } catch {
//            print("error: \(error)")
//        }
//        }
        var context: [NSManagedObjectContext] = [coreDataStack.saveContext]
        if let parentContext = saveContext.parent {
            context.append(parentContext)
            if let parent = parentContext.parent {
                context.append(parent)
            }
        }
        for context in context {
            deleteAllRecords(with: context)
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
            let person = NSManagedObject(entity: entity, insertInto: context)
            if name != nil {
                person.setValue(name, forKeyPath: "name")
            }
            if about != nil {
                person.setValue(about, forKeyPath: "about")
            }
            if image != nil {
                person.setValue(image, forKey: "image")
            }
        }
        performSave(with: coreDataStack.saveContext)
    }
    func saveMessageModel(messageModel: MessageModel) {
        deleteMessage(with: coreDataStack.saveContext, name: messageModel.name ?? "")
        var context: [NSManagedObjectContext] = [coreDataStack.saveContext]
        if let parentContext = saveContext.parent {
            context.append(parentContext)
            if let parent = parentContext.parent {
                context.append(parent)
            }
        }
        for context in context {
            let entity = NSEntityDescription.entity(forEntityName: "Message", in: context)!
            let message = NSManagedObject(entity: entity, insertInto: context)
            message.setValue(messageModel.date, forKey: "date")
            message.setValue(messageModel.hasUnreadMessages, forKey: "hasUnreadMessages")
            message.setValue(messageModel.message, forKey: "message")
            message.setValue(messageModel.name, forKey: "name")
            message.setValue(messageModel.online, forKey: "online")
        }
        performSave(with: coreDataStack.saveContext)
    }
    func saveDialog(conversationID: String, from: String, message: String) {
        let context: [NSManagedObjectContext] = [coreDataStack.saveContext]
//        if let parentContext = saveContext.parent {
//            context.append(parentContext)
//            if let parent = parentContext.parent {
//                context.append(parent)
//            }
//        }
        for context in context {
            let entity = NSEntityDescription.entity(forEntityName: "Conversation", in: context)!
            let dialog = NSManagedObject(entity: entity, insertInto: context)
            dialog.setValue(from, forKey: "from")
            dialog.setValue(message, forKey: "message")
            dialog.setValue(Date(), forKey: "date")
            dialog.setValue(conversationID, forKey: "conversationID")
        }
        performSave(with: coreDataStack.saveContext)
    }
    func terminateSave() {
        performSave(with: saveContext)
    }
    private func deleteMessage(with context: NSManagedObjectContext, name: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        deleteFetch.predicate = NSPredicate(format: "name == %@", name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        if let parentContext = context.parent {
            deleteAllRecords(with: parentContext)
        }
    }
    private func deleteAllRecords(with context: NSManagedObjectContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        if let parentContext = context.parent {
            deleteAllRecords(with: parentContext)
        }
    }
    private func performSave(with context: NSManagedObjectContext, completion: SaveCompletion? = nil) {
        guard context.hasChanges else {
            completion?()
            return
        }
        context.perform {
            do {
                try context.save()
            } catch {
                print("Context save error \(error)")
            }
        }
        if let parentContext = context.parent {
            performSave(with: parentContext, completion: completion)
        } else {
            completion?()
        }
    }
    func fetchProfile() -> [String: Data] {
        let managedContext = coreDataStack.masterContext
        let user = StorageManager.findOrInsertUser(in: managedContext)
        guard let name = (user?.name?.data(using: .utf8)),
            let about = (user?.about?.data(using: .utf8)),
            let image = user?.image else {
            return ["name": UIDevice.current.name.data(using: .utf8)!,
                    "about": "about you".data(using: .utf8)!]
        }
        return ["name": name,
                "about": about,
                "image": image]
    }
    static func findOrInsertUser(in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("model is not available in context!")
            assert(false)
            return nil
        }
        var user: User?
        guard let fetchRequest = User.fetchRequestUser(model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            //assert(results.count < 2, "Multiple AppUser found!")
            if let foundUser = results.last {
                user = foundUser
            }
        } catch {
            print("Failed to fetch User \(error)")
        }
        if user == nil {
            user = User.insertUser(in: context)
        }
        return user
    }
}
