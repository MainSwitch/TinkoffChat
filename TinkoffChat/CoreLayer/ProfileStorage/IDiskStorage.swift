//
//  IDiskStorage.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

protocol IDiskStorage {
    func performSave(with context: NSManagedObjectContext, completion: StorageManager.SaveCompletion?)
}
