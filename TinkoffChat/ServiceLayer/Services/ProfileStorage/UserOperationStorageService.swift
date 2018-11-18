//
//  OperationDataManager.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

class SaveUserOperation: Operation {
    private let userManager: UserFileStorage
    private let user: ProfileUser
    var hasError: Bool = false
    init(userManager: UserFileStorage, user: ProfileUser) {
        self.userManager = userManager
        self.user = user
        super.init()
    }
    override func main() {
        if self.isCancelled { return }
        self.hasError = self.userManager.save(user: self.user)
    }
}

class LoadUserOperation: Operation {
    private let userManager: UserFileStorage
    var user: ProfileUser?
    init(userManager: UserFileStorage) {
        self.userManager = userManager
        super.init()
    }
    override func main() {
        if self.isCancelled { return }
        self.user = self.userManager.get()
    }
}
