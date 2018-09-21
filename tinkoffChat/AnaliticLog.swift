//
//  AnaliticLog.swift
//  tinkoffChat
//
//  Created by Anton on 20.09.2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class AnaliticLog {
    
    private let isNeedLog: Bool
    
    init(needForLogs: Bool) {
        self.isNeedLog = needForLogs
    }
    
    func log(logCode: ()->()) {
        if isNeedLog{
            logCode()
        }
    }
}
