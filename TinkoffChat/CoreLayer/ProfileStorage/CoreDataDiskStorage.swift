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
    func fetchProfile(key: String) -> UIImage? {
        <#code#>
    }
}
