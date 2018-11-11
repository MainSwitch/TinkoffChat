//
//  User.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 09/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

extension User {
    static func insertUser(in context: NSManagedObjectContext) -> User? {
        guard let user =
            NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
                return nil
        }
        user.name = UIDevice.current.name
        user.about = ""
        return user
    }
    static func fetchRequestUser(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "User"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
}

extension Conversation {
    func printUserName() {
        print("from: \(String(describing: self.from)) message: \(self.message!)")
    }
}
