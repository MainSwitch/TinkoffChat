//
//  SaveOperation.swift
//  tinkoffChat
//
//  Created by Anton on 20/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

protocol ProfileDataSaveManager {
    var errors: [SaveError] {get set}
    var userName: String? {get set}
    var image: UIImage? {get set}
    var about: String? {get set}
    var customCompletionBlock: (() -> Void)? {get set}
    
    func saveData(name: String?, about: String?, image: UIImage?)
    func getData()
}
