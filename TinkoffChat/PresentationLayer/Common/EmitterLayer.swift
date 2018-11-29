//
//  EmitterLayer.swift
//  tinkoffChat
//
//  Created by Антон Потапов on 29/11/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit

class EmitterLayer {
    var emitterLayer = CAEmitterLayer()
    var tapView: UIView
    init(view: UIView) {
        self.tapView = view
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTouch))
//        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panSlide))
//        let longRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longTouch))
//        tapView.addGestureRecognizer(tapRecognizer)
//        tapView.addGestureRecognizer(panRecognizer)
//        tapView.addGestureRecognizer(longRecognizer)
        let gestureRC = GestureRC(target: self, action: #selector(recognizer))
        tapView.addGestureRecognizer(gestureRC)
    }
    @objc private func longTouch(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.location(in: tapView)
            self.setEmitterLayer(point: point, parentView: tapView)
        case .ended:
            emitterLayer.removeFromSuperlayer()
        default:
            emitterLayer.removeFromSuperlayer()
        }
    }
    @objc private func recognizer(_ sender: GestureRC) {
        switch sender.state {
        case .began:
            let point = sender.location(in: tapView)
            setEmitterLayer(point: point, parentView: tapView)
        case .changed:
            let point = sender.location(in: tapView)
            emitterLayer.emitterPosition = point
        default:
            emitterLayer.removeFromSuperlayer()
        }
    }
    @objc private func panSlide(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.translation(in: tapView)
            setEmitterLayer(point: point, parentView: tapView)
        case .changed:
            let point = sender.location(in: tapView)
            emitterLayer.emitterPosition = point
        case .ended:
            emitterLayer.removeFromSuperlayer()
        default:
            emitterLayer.removeFromSuperlayer()
        }
    }
    @objc private func tapTouch(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: tapView)
        self.setEmitterLayer(point: point, parentView: tapView)
        switch sender.state {
        case .ended:
            emitterLayer.removeFromSuperlayer()
        default:
            emitterLayer.removeFromSuperlayer()
        }
    }
    func setEmitterLayer(point: CGPoint, parentView: UIView) {
        let sizeLayer = CGSize(width: 50, height: 50)
        let rect = CGRect(x: point.x, y: point.y, width: sizeLayer.width, height: sizeLayer.height)
        emitterLayer.frame = rect
        parentView.layer.addSublayer(emitterLayer)
        //emitterLayer.emitterShape = kCAEmitterLayerPoints
        emitterLayer.emitterSize = rect.size
        let emitterCell = CAEmitterCell()
        let image = UIImage(named: "tinkoff-bank")?.resized(toWidth: 42)
        emitterCell.contents = image?.cgImage
        emitterCell.birthRate = 50
        emitterCell.lifetime = 1.5
        emitterCell.lifetimeRange = 1
        emitterCell.yAcceleration = 60.0
        emitterCell.xAcceleration = -10
        emitterCell.velocity = 60
        emitterCell.velocityRange = 200
        emitterCell.emissionLongitude = -.pi * 0.5
        emitterCell.emissionRange = .pi * 1
        emitterCell.redRange = 0.3
        emitterCell.greenRange = 0.3
        emitterCell.blueRange = 0.3
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        emitterCell.alphaRange = 0.7
        emitterCell.alphaSpeed = -0.15
        emitterLayer.emitterCells = [emitterCell]
    }
}

class GestureRC: UIGestureRecognizer {
    var minimumPressDuration = UILongPressGestureRecognizer().minimumPressDuration
    var allowableMovement = UILongPressGestureRecognizer().allowableMovement
    var previousLocation: CGPoint?
    var longPressTimer: Timer?
    var inProgress = false
    var touchMoveDistance: CGFloat = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        let touchMoveDistance = 0.0
        previousLocation = touches.first?.location(in: view)
        let longPressTimer = Timer.scheduledTimer(timeInterval: minimumPressDuration, target: self, selector: #selector(onTimer), userInfo: nil, repeats: false)
        if inProgress == false {//inProgress will return true when stati is either .began or .changed
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let newLocation = touches.first?.location(in: view), let previousLocation = previousLocation {
            self.previousLocation = newLocation
            touchMoveDistance += abs(previousLocation.y - newLocation.y) + abs(previousLocation.x - newLocation.x)
        }
        if inProgress == false {
            super.touchesMoved(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        longPressTimer?.invalidate()
        longPressTimer = nil
        if inProgress {
            state = .ended
        }
        super.touchesEnded(touches, with: event)
        if self.isEnabled {//This will simply reset the gesture
            self.isEnabled = false
            self.isEnabled = true
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        longPressTimer?.invalidate()
        longPressTimer = nil
        if inProgress {
            state = .ended
        }
        super.touchesCancelled(touches, with: event)
        if self.isEnabled {
            self.isEnabled = false
            self.isEnabled = true
        }
    }
    @objc private func onTimer() {
        longPressTimer?.invalidate()
        longPressTimer = nil
        if state == .possible {
            state = .began
        }
    }
}
