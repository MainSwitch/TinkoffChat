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
//        managedObjectModel = coreDataStack.managedObjectModel
//        persistentStoreCoordinator = coreDataStack.persistentStoreCoordinator
//        masterContext = coreDataStack.masterContext
//        mainContext = coreDataStack.mainContext
        saveContext = coreDataStack.saveContext
    }
    typealias SaveCompletion = () -> Void
    func savePrifileData(name: String?,
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
            let entity = NSEntityDescription.entity(forEntityName: "AppUser", in: context)!
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
    func terminateSave() {
        performSave(with: saveContext)
    }
    private func deleteAllRecords(with context: NSManagedObjectContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
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
    func fetch() -> [String: Data] {
        let managedContext = coreDataStack.masterContext
        let appUser = StorageManager.findOrInsertAppUser(in: managedContext)
        guard let name = (appUser?.name?.data(using: .utf8)),
            let about = (appUser?.about?.data(using: .utf8)),
            let image = appUser?.image else {
            return ["name": UIDevice.current.name.data(using: .utf8)!,
                    "about": "about you".data(using: .utf8)!]
        }
        return ["name": name,
                "about": about,
                "image": image]
    }
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("model is not available in context!")
            assert(false)
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            //assert(results.count < 2, "Multiple AppUser found!")
            if let foundUser = results.last {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser \(error)")
        }
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        return appUser
    }
}

extension AppUser {
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let appUser =
            NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {
            return nil
        }
        appUser.name = UIDevice.current.name
        appUser.about = ""
        return appUser
    }
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
}
