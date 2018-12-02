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
    var swiped = false
    var lastPoint = CGPoint.zero
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layer = EmitterLayer()
        let longRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panSlide))
        panRecognizer.delegate = self
        longRecognizer.delegate = self
        view.addGestureRecognizer(longRecognizer)
        view.addGestureRecognizer(panRecognizer)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layer = nil
    }
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.location(in: view)
            layer?.setEmitterLayer(point: point, parentView: view)
        default:
            break
        }
    }
    @objc func panSlide(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.translation(in: view)
            layer?.setEmitterLayer(point: point, parentView: view)
        case .changed:
            let point = sender.location(in: view)
            layer?.emitterLayer.emitterPosition = point
        case .ended:
            layer?.emitterLayer.removeFromSuperlayer()
        default:
            layer?.emitterLayer.removeFromSuperlayer()
        }
    }
}

extension CommonViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
