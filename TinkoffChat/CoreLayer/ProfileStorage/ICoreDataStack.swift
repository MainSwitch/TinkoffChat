//
//  ICoreDataStack.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    var masterContext: NSManagedObjectContext { get set }
    var mainContext: NSManagedObjectContext { get set }
    var saveContext: NSManagedObjectContext { get set }
}
