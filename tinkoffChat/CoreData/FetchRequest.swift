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
    init(managedObjectContext: NSManagedObjectContext) {
        self.context = managedObjectContext
    }
    func fetchRequestWithPredicateExample() {
        print("Fetch request with predicate:")
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "Alice")
        let result = try? context.fetch(request)
        if let result = result {
            result.forEach { $0.printUserName() }
        }
        print("")
    }
}
