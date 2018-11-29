//
//  CommonViewController.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 29/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    var layer: EmitterLayer?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layer = EmitterLayer(view: view)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layer = nil
    }
}
