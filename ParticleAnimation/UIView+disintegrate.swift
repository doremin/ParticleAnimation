//
//  UIView+disintegrate.swift
//  ParticleAnimation
//
//  Created by doremin on 6/25/25.
//

import UIKit

extension UIView {
    func disintegrate(maxTiles: Int = 2000) {
        guard let superview = self.superview else { return }
        
        // Take snapshot
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()
        
        let imageWidth = snapshotImage.width
        let imageHeight = snapshotImage.height
        let scale = UIScreen.main.scale
        let maxTiles = maxTiles
        let totalPixels = imageWidth * imageHeight
        let estimatedPixelArea = CGFloat(totalPixels) / CGFloat(maxTiles)
        let pixelSize = ceil(sqrt(estimatedPixelArea)) / scale
        self.removeFromSuperview()
        
        for x in stride(from: 0, to: imageWidth, by: Int(pixelSize * scale)) {
            for y in stride(from: 0, to: imageHeight, by: Int(pixelSize * scale)) {
                let rect = CGRect(x: x, y: y, width: Int(pixelSize * scale), height: Int(pixelSize * scale))
                guard let tileImage = snapshotImage.cropping(to: rect) else { continue }
                
                let tileLayer = CALayer()
                tileLayer.contents = tileImage
                tileLayer.frame = CGRect(
                    x: self.frame.origin.x + CGFloat(x) / scale,
                    y: self.frame.origin.y + CGFloat(y) / scale,
                    width: pixelSize,
                    height: pixelSize
                )
                
                superview.layer.addSublayer(tileLayer)
                
                let dx = CGFloat.random(in: 100...900)
                let dy = CGFloat.random(in: -300...100)
                let duration = 1.5
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.fromValue = tileLayer.position
                animation.toValue = CGPoint(
                    x: tileLayer.position.x + dx,
                    y: tileLayer.position.y + dy
                )
                
                let fade = CABasicAnimation(keyPath: "opacity")
                fade.fromValue = 1
                fade.toValue = 0
                
                let scale = CABasicAnimation(keyPath: "transform.scale")
                scale.fromValue = 1
                scale.toValue = 0.1
                
                let group = CAAnimationGroup()
                group.animations = [animation, fade, scale]
                group.duration = duration
                group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                group.fillMode = .forwards
                group.isRemovedOnCompletion = false
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    tileLayer.removeFromSuperlayer()
                }
                tileLayer.add(group, forKey: nil)
                CATransaction.commit()
            }
        }
    }
}
