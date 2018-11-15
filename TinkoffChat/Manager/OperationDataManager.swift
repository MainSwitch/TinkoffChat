//
//  OperationDataManager.swift
//  tinkoffChat
//
//  Created by Anton on 18/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

enum SaveError: Error {
    case enumerating(reason: String)
    case dontSave(reason: String)
}

class OperationDataManager: AsyncOperation, ProfileDataSaveManager {
    let fileManager = FileManager.default
    let userDefaults = UserDefaults.standard
    var errors: [SaveError] = []
    var userName: String?
    var image: UIImage?
    var about: String?
    let operation: OperationType
    var customCompletionBlock: (() -> Void)?
    convenience override init() {
        self.init(image: nil, name: nil, about: nil, completionBlock: nil, opration: .none)
    }
    init(image: UIImage?,
         name: String?,
         about: String?,
         completionBlock: (() -> Void)?,
         opration: OperationType) {
        self.userName = name
        self.image = image
        self.about = about
        self.operation = opration
        self.customCompletionBlock = completionBlock
    }
    enum OperationType {
        case get
        case write
        case none
    }
    func saveName(name: String?) {
        guard let name = name else {
            return
        }
        if name != getName() {
            if getName() == nil {
                finish(withError: .dontSave(reason: "save Error"))
                return
            }
            userDefaults.set(name, forKey: "name")
        }
    }
    func saveAbout(about: String?) {
        guard let about = about else {
            return
        }
        if about != getAbout() {
            if getName() == nil {
                finish(withError: .dontSave(reason: "save Error"))
                return
            }
            userDefaults.set(about, forKey: "about")
        }
    }
    func saveImage(image: UIImage?) {
        let imageFromURL = getImage()
        guard let image = image else {
            return
        }
        if let data = image.pngData() {
            if let existImage = imageFromURL, existImage.count != data.count {
                let fileName = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: fileName)
            } else if imageFromURL == nil {
                let fileName = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: fileName)
                if getName() == nil {
                    finish(withError: .dontSave(reason: "save Error"))
                    return
                }
            }
        } else {
            finish(withError: .dontSave(reason: "save error"))
        }
    }
    func getName() -> String? {
        return userDefaults.string(forKey: "name")
    }
    func getAbout() -> String? {
        return userDefaults.string(forKey: "about")
    }
    func getImage() -> Data? {
        var imageFromURL: Data?
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: getDocumentsDirectory(),
                                                               includingPropertiesForKeys: nil)
            // process files
            if let path = fileURLs.first?.path {
                let imageData = fileManager.contents(atPath: path)
                if let imageData = imageData {
                    imageFromURL = imageData
                } else {
                    print("Не удалось преобразовать картинку")
                }
            } else {
                print("Не удалось выполнить сохранение")
            }
        } catch {
            print("Не удалось выполнить сохранение")
        }
        return imageFromURL
    }
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getData() {
        if let imageData = getImage() {
            self.image = UIImage(data: imageData)
        }
        self.userName = getName()
        self.about = getAbout()
    }
    func saveData(name: String?, about: String?, image: UIImage?) {
        saveImage(image: image)
        saveName(name: name)
        saveAbout(about: about)
        self.userDefaults.synchronize()
    }
    override func execute() {
        self.completionBlock = customCompletionBlock
        switch operation {
        case .write:
            saveData(name: self.name, about: self.about, image: self.image)
        case .get:
            getData()
        case .none:
            break
        }
    }
    func finish(withError errors: SaveError) {
        self.errors = [errors]
        isFinished = true
    }
}
class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    var isFinishedOperation: Bool = false
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            isFinishedOperation = newValue
            didChangeValue(forKey: "isFinished")
        }
        get {
            return isFinishedOperation
        }
    }
    var isExecutingOeration: Bool = false
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            isExecutingOeration = newValue
            didChangeValue(forKey: "isExecuting")
        }
        get {
            return isExecutingOeration
        }
    }
    func execute() {
    }
    override func start() {
        isExecuting = true
        execute()
        isExecuting = false
        isFinished = true
    }
}
