//
//  SaveOperation.swift
//  tinkoffChat
//
//  Created by Anton on 20/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol SaveOperation {
    var errors: [SaveError] {get set}
    var userName: String? {get set}
    var image: UIImage? {get set}
    var about: String? {get set}
    var customCompletionBlock: (() -> Void)? {get set}
    
    func saveName(name: String?)
    func saveAbout(about: String?)
    func saveImage(image: UIImage?)
    func getName() -> String?
    func getAbout() -> String?
    func getImage() -> Data?
    func saveData()
    func getData()
}
