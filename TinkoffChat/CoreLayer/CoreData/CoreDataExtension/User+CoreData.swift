//
//  User+CoreData.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import CoreData

extension User {
    static func insertUser(with userId: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = userId
            return user
        }
        return nil
    }
    static func findOrInsertUser(with userId: String,
                                 in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        var user: User?
        guard let fetchRequest = User.fetchRequestUser(with: userId, model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Appuser found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print ("Failed to fetch user: \(error)")
        }
        if user == nil {
            user = User.insertUser(with: userId, in: context)
        }
        return user
    }
    static func fetchRequestUser(with userId: String,
                                 model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "UserById"
        guard let fetchRequest =
            model.fetchRequestFromTemplate(withName: templateName,
                                 substitutionVariables: ["userId": userId]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
}
