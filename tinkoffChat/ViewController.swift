//
//  ViewController.swift
//  tinkoffChat
//
//  Created by Anton on 20.09.2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let logManager = AnaliticLog(needForLogs: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logManager.log {
            print("View is loaded into memory: \(#function)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logManager.log {
            print("View moved from 'Disappeared' to 'Appearing': '\(#function)'")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logManager.log {
        print("View moved from 'Appearing' to 'Appear': '\(#function)'")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logManager.log {
            print("View moved from 'Appearing' to 'Appearing': '\(#function)'")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logManager.log {
            print("View moved from 'Appearing' to 'Appearing': '\(#function)'")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logManager.log {
            print("View moved from 'Appear' to 'Disappearing': '\(#function)'")
        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logManager.log {
            print("View moved from 'Disappearing' to 'Disappeared': '\(#function)'")
        }
    }
}

