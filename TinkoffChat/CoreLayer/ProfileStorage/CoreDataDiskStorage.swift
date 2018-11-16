//
//  ProfileDiskStorage.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDiskStorage: IProfileStorage {
    var coreDataStack: ICoreDataStack
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    func save(name: String?, about: String?, image: Data?) {
        let saveContext = coreDataStack.saveContext
        var context: [NSManagedObjectContext] = [saveContext]
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
    func fetchProfile() -> [String: Data]? {
        let managedContext = coreDataStack.masterContext
        let user = CoreDataDiskStorage.findOrInsertUser(in: managedContext)
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
    // MARK: - Private methods
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
    private static func findOrInsertUser(in context: NSManagedObjectContext) -> User? {
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
    private func performSave(with context: NSManagedObjectContext, completion: (() -> Void)? = nil) {
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
}
