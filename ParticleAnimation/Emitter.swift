//
//  Emitter.swift
//  ParticleAnimation
//
//  Created by doremin on 6/25/25.
//

import UIKit
import SubviewHierarchy

final class EmitterViewController: UIViewController {
    lazy var box1: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.frame = CGRect(x: 100, y: 200, width: 200, height: 300)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view {
            box1
        }
    }
    
    @objc private func didTap() {
        let representativeColor = box1.backgroundColor?.cgColor ?? UIColor.gray.cgColor

        let emitter = CAEmitterLayer()
        emitter.frame = box1.bounds
        emitter.emitterPosition = CGPoint(x: box1.bounds.midX, y: box1.bounds.midY)
        emitter.emitterShape = .rectangle
        emitter.emitterSize = box1.bounds.size
        emitter.renderMode = .additive

        let cell = CAEmitterCell()
        cell.contents = makeSquareParticleImage(color: representativeColor)?.cgImage
        cell.birthRate = 50000
        cell.beginTime = CACurrentMediaTime()
        cell.emissionRange = .pi * 2
        cell.lifetime = 1.5
        cell.velocity = 150
        cell.velocityRange = 50
        cell.scale = 0.3
        cell.scaleRange = 0.01
        cell.alphaSpeed = -0.5

        emitter.emitterCells = [cell]
        emitter.position = box1.center
        emitter.frame = box1.frame
        view.layer.addSublayer(emitter)
        box1.isHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            emitter.birthRate = 0
        }
    }

    // 네모 파편 이미지 생성
    private func makeSquareParticleImage(color: CGColor) -> UIImage? {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color)
        context.fill(CGRect(origin: .zero, size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

