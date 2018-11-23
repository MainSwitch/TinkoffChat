//
//  CoreAssembly.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack {get}
    var multipeerCommuncator: ICommunicator {get}
    var communicatorStorageService: ICommunicatorStorageService {get}
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
    lazy var multipeerCommuncator: ICommunicator = NewMultipeerCommunicator()
    lazy var communicatorStorageService: ICommunicatorStorageService =
        CommunicatorStorageService(dataStack: self.coreDataStack, communicator: self.multipeerCommuncator)
    lazy var requestSender: IRequestSender = RequestSender()
}
