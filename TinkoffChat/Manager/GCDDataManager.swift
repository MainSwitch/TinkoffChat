//
//  GCDDataManager.swift
//  tinkoffChat
//
//  Created by Anton on 18/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class GCDDataManager: ProfileDataSaveManager {
    let fileManager = FileManager.default
    let userDefaults = UserDefaults.standard
    var errors: [SaveError] = []
    var userName: String?
    var image: UIImage?
    var about: String?
    var customCompletionBlock: (() -> Void)?
    let saveQueue = DispatchQueue(label: "com.tinkoffChat.queue",
                                  qos: .background,
                                  attributes: DispatchQueue.Attributes.concurrent)
    init(completionBlock: (() -> Void)?) {
        self.customCompletionBlock = completionBlock
    }
    func saveName(name: String?) {
        guard let name = name else {
            return
        }
        if name != self.getName() {
            self.userDefaults.set(name, forKey: "name")
        }
        guard self.getName() != nil else {
            self.finish(withError: .dontSave(reason: "save Error"))
            return
        }
    }
    func saveAbout(about: String?) {
        guard let about = about else {
            return
        }
        if about != self.getAbout() {
            self.userDefaults.set(about, forKey: "about")
        }
        guard self.getAbout() != nil else {
            self.finish(withError: .dontSave(reason: "save Error"))
            return
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
                guard getImage() != nil else {
                    finish(withError: .dontSave(reason: "save Error"))
                    return
                }
            }
        }    }
    func saveData(name: String?, about: String?, image: UIImage?) {
        let workItem = DispatchWorkItem {
            self.saveImage(image: image)
            self.saveName(name: name)
            self.saveAbout(about: about)
            self.userDefaults.synchronize()
        }
        saveQueue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            self.customCompletionBlock?()
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finish(withError errors: SaveError) {
        self.errors = [errors]
    }
    func getData() {
        let workItem = DispatchWorkItem {
            if let imageData = self.getImage() {
                self.image = UIImage(data: imageData)
            }
            self.userName = self.getName()
            self.about = self.getAbout()
        }
        saveQueue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            self.customCompletionBlock?()
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
}