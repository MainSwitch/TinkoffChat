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
    var fetchedResultsController: NSFetchedResultsController<Conversation>
    init(managedObjectContext: NSManagedObjectContext,
         fetchedResultsController: NSFetchedResultsController<Conversation>) {
        context = managedObjectContext
        self.fetchedResultsController = fetchedResultsController
    }
    func fetchRequestConversation(with userName: String) {
        print("Fetch request with predicate:")
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "Alice")
        let result = try? context.fetch(request)
        if let result = result {
            result.forEach { $0.printUserName() }
        }
        print("")
    }
}
