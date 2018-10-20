//
//  OperationDataManager.swift
//  tinkoffChat
//
//  Created by Anton on 18/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class OperationDataManager: AsyncOperation {
    let fileManager = FileManager.default
    let userDefaults = UserDefaults.standard
    var errors: [SaveError] = []
    var userName: String?
    var image: UIImage?
    var about: String?
    let operation: OperationType
    
    convenience override init() {
        self.init(image: nil, name: nil, about: nil, opration: .none)
    }
    
    init(image: UIImage?,name: String?,about: String?, opration: OperationType) {
        self.userName = name
        self.image = image
        self.about = about
        self.operation = opration
    }
    
    enum SaveError: Error {
        case enumerating(reason: String)
        case dontSave(reason: String)
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
            userDefaults.set(name, forKey: "name")
        }
    }
    
    func saveAbout(about: String?) {
        guard let about = about else {
            return
        }
        if about != getAbout() {
            userDefaults.set(about, forKey: "about")
        }
    }
    
    func saveImage(image: UIImage?){
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
            }
        }
    }
    
    func getName() -> String? {
        return userDefaults.string(forKey: "name")
    }
    
    func getAbout() -> String? {
        return userDefaults.string(forKey: "about")
    }
    
    func getImage() -> Data? {
        var imageFromURL: Data? = nil
        do {
            var fileURLs = try fileManager.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)
            // process files
            if let path = fileURLs.first?.path {
                let imageData = fileManager.contents(atPath: path)
                if let imageData = imageData {
                    imageFromURL = imageData
                } else {
                    finish(withError: .dontSave(reason: "Не удалось преобразовать картинку"))
                }
            } else {
                finish(withError: .dontSave(reason: "Не удалось выполнить сохранение"))
            }
        } catch {
            finish(withError: .enumerating(reason: "Error while enumerating files"))
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
    
    override func execute() {
        switch operation {
        case .write:
            saveImage(image: self.image)
            saveName(name: self.userName)
            saveAbout(about: self.about)
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
    
    var _isFinished: Bool = false
    
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
        
        get {
            return _isFinished
        }
    }
    
    var _isExecuting: Bool = false
    
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
        
        get {
            return _isExecuting
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
