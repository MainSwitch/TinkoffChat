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
    var viewState = StateSingleton.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        logManager.log {
            print("View is loaded into memory: \(#function)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logManager.logState(form: "Disappeared", to: "Appearing", funcName: #function)
        viewState.viewState = "Appearing"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logManager.logState(form: viewState.viewState!, to: "Appear", funcName: #function)
        viewState.viewState = "Appear"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logManager.logState(form: viewState.viewState!, to: "Appearing", funcName: #function)
        viewState.viewState = "Appearing"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logManager.logState(form: viewState.viewState!, to: "Appearing", funcName: #function)
        viewState.viewState = "Appearing"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logManager.logState(form: viewState.viewState!, to: "Disappearing", funcName: #function)
        viewState.viewState = "Disappearing"
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logManager.logState(form: viewState.viewState!, to: "Disappeared", funcName: #function)
        viewState.viewState = "Disappeared"
    }
}

