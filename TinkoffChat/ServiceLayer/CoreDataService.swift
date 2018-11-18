//
//  CoreDataService.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataService {
    var mainContext: NSManagedObjectContext {get}
    var saveContext: NSManagedObjectContext {get}
     func performSave(context: NSManagedObjectContext,
                      completionHandler: (() -> Void)?)
}

class CoreDataService: ICoreDataService {
    private var coreData: ICoreDataStack
    var mainContext: NSManagedObjectContext {
        get { return self.coreData.mainContext }
        set {}
    }
    var saveContext: NSManagedObjectContext { return self.coreData.saveContext }
    init(coreData: ICoreDataStack) {
        self.coreData = coreData
    }
    func performSave(context: NSManagedObjectContext, completionHandler: (() -> Void)?) {
        self.coreData.performSave(context: context, completionHandler: completionHandler)
    }
}
