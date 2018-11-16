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
    var coreDataStack: ICoreDataStack {get}
    var multipeerCommuncator: ICommunicator {get}
    var communicatorStorageService: ICommunicatorStorageService {get}
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    var coreDataStack: ICoreDataStack
    
    var multipeerCommuncator: ICommunicator
    
    var communicatorStorageService: ICommunicatorStorageService
    
    lazy var diskProfileStorage: IProfileStorage = CoreDataDiskStorage(coreDataStack: CoreDataStack())
}
