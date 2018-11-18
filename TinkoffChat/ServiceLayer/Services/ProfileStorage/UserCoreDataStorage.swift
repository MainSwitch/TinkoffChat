//
//  UserCoreDataStorage.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 16/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

protocol IUserStorageService {
    func saveUser(user: ProfileUser,
                  completionClosure: @escaping (_ withError: Bool) -> Void)
    func loadUser(completionClosure: @escaping (_ user: ProfileUser?) -> Void)
}

class UserCoreDataStorage: IUserStorageService {
    private var dataStack: ICoreDataStack
    init(dataStack: ICoreDataStack) {
        self.dataStack = dataStack
    }
    func saveUser(user: ProfileUser,
                  completionClosure: @escaping (Bool) -> Void) {
        let context = self.dataStack.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            if user.usernameWasEdited {
                appUser.name = user.username
            }
            if user.descriptionWasEdited {
                appUser.details = user.description
            }
            if user.avatarWasEdited {
                appUser.avatar = user.avatar
            }
            self.dataStack.performSave(context: context) {
                DispatchQueue.main.async {
                    completionClosure(false)
                }
            }
        }
    }
    func loadUser(completionClosure: @escaping (ProfileUser?) -> Void) {
        let context = self.dataStack.saveContext
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            if appUser.name == nil && appUser.details == nil && appUser.avatar == nil {
                completionClosure(nil)
            } else {
                let profileUser =
                    ProfileUser(username: appUser.name,
                                description: appUser.details,
                                avatar: appUser.avatar as? UIImage)
                DispatchQueue.main.async {
                    completionClosure(profileUser)
                }
            }
        }
    }
}
