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
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panSlide))
        tapView.addGestureRecognizer(panRecognizer)
    }
    private func setEmitterLayer(point: CGPoint, parentView: UIView) {
        let sizeLayer = CGSize(width: 50, height: 50)
        let rect = CGRect(x: point.x, y: point.y, width: sizeLayer.width, height: sizeLayer.height)
        emitterLayer.frame = rect
        parentView.layer.addSublayer(emitterLayer)
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        emitterLayer.emitterSize = rect.size
        let emitterCell = CAEmitterCell()
        let image = UIImage(named: "tinkoff-bank")?.resized(toWidth: 42)
        emitterCell.contents = image?.cgImage
        emitterCell.lifetime = 1.0
        emitterCell.birthRate = 40
        emitterCell.alphaSpeed = -0.4
        emitterCell.velocity = 50
        emitterCell.velocityRange = 90
        emitterCell.emissionRange = CGFloat.pi * 2
        emitterLayer.emitterCells = [emitterCell]
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
}
