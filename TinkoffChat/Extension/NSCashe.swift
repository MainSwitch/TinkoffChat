//
//  NSCashe.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 23/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import Foundation

extension NSCache {
    @objc class var sharedInstance: NSCache<NSString, AnyObject> {
        let cache = NSCache<NSString, AnyObject>()
        return cache
    }
}
