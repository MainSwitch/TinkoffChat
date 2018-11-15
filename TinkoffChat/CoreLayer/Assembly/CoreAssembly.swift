//
//  CoreAssembly.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var diskProfileStorage: IProfileStorage { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var diskProfileStorage: IProfileStorage = CoreDataDiskStorage(coreDataStack: CoreDataStack())
}
