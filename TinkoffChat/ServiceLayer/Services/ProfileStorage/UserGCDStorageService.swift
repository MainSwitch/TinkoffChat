//
//  GCDDataManager.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

class NewGCDDataManager: IUserStorageService {
    private let userManager: UserFileStorage = UserFileStorage()
    func saveUser(user: ProfileUser, completionClosure: @escaping (_ withError: Bool) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let hasError = self.userManager.save(user: user)
            DispatchQueue.main.async {
                completionClosure(hasError)
            }
        }
    }
    func loadUser(completionClosure: @escaping (_ user: ProfileUser?) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            let loadedUser = self.userManager.get()
            DispatchQueue.main.async {
                completionClosure(loadedUser)
            }
        }
    }
}
