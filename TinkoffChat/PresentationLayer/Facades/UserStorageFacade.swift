//
//  UserStorageFacade.swift
//  tinkoffChat
//
//  Created by Anton on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

enum UserStorageType {
    case coreDataStorage
    case gcdStorage
    case operation
}

protocol IUserStorageFacade {
    func selectStrategy(userStorageService: UserStorageType)
    func updateUser(user: ProfileUser,
                    completionClosure: @escaping (_ withError: Bool) -> Void)
    func getUser(completionClosure: @escaping (_ user: ProfileUser?) -> Void)
}

class UserStorageFacade: IUserStorageFacade {
    private var userStorageService: IUserStorageService
    private var userCoreDataStorage: UserCoreDataStorage
    init(userStorageService: IUserStorageService, userCoreDataStorage: UserCoreDataStorage) {
        self.userStorageService = userStorageService
        self.userCoreDataStorage = userCoreDataStorage
    }
    func selectStrategy(userStorageService userStorageType: UserStorageType) {
        switch userStorageType {
        case .gcdStorage:
            self.userStorageService = NewGCDDataManager()
        case .coreDataStorage:
            self.userStorageService = self.userCoreDataStorage
        default:
            break
        }
    }
    func updateUser(user: ProfileUser,
                    completionClosure: @escaping (_ withError: Bool) -> Void) {
        // need convert to display model
        self.userStorageService.saveUser(user: user, completionClosure: completionClosure)
    }
    func getUser(completionClosure: @escaping (_ user: ProfileUser?) -> Void) {
        // need convert to display model
        self.userStorageService.loadUser(completionClosure: completionClosure)
    }
}
