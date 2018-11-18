//
//  UserFileStorage.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 15/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class UserFileStorage {
    private let imageFilename = "avatar.png"
    private let usernameFilename = "username.txt"
    private let descriptionFilename = "description.txt"
    func save(user: ProfileUser) -> Bool {
        do {
            let filePath = self.getDocumentsDirectory()
            if user.usernameWasEdited, let usernameUnwrapped = user.username {
                try usernameUnwrapped.write(to: filePath.appendingPathComponent(self.usernameFilename),
                                            atomically: false,
                                            encoding: String.Encoding.utf8)
            }
            if user.descriptionWasEdited, let descriptionUnwrapped = user.description {
                try descriptionUnwrapped.write(to: filePath.appendingPathComponent(self.descriptionFilename),
                                               atomically: false,
                                               encoding: String.Encoding.utf8)
            }
            if user.avatarWasEdited, let avatarUnwrapped = user.avatar {
                let imageData = avatarUnwrapped.pngData()
                try imageData?.write(to: filePath.appendingPathComponent(self.imageFilename), options: .atomic)
            }
            return false
        } catch {
            return true
        }
    }
    func get() -> ProfileUser? {
        do {
            let user: ProfileUser = ProfileUser()
            let filePath = getDocumentsDirectory()
            user.username = try String(contentsOf: filePath.appendingPathComponent(self.usernameFilename))
            user.description = try String(contentsOf: filePath.appendingPathComponent(self.descriptionFilename))
            user.avatar = UIImage(contentsOfFile: filePath.appendingPathComponent(self.imageFilename).path)
            return user
        } catch {
            return nil
        }
    }
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
