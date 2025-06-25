//
//  Particle.swift
//  ParticleAnimation
//
//  Created by doremin on 6/25/25.
//

import UIKit

import SubviewHierarchy

final class ParticleViewController: UIViewController {
    
    let box: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "asdasd"
        label.textColor = .red
        return label
    }()
    
    let revertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("revert", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .yellow
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        box.addGestureRecognizer(tapGesture)
        box.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        box.center = view.center
        textLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        textLabel.center = CGPoint(x: 100, y: 100)
        revertButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        revertButton.center = CGPoint(x: view.center.x, y: view.center.y + 300)
        revertButton.addTarget(self, action: #selector(handleRevertTap), for: .touchUpInside)
        starImageView.frame = CGRect(x: 30, y: 20, width: 40, height: 40)
        
        
        view {
            box {
                textLabel
                starImageView
                
                let box2: UIView = {
                    let view = UIView()
                    view.backgroundColor = .systemRed
                    view.layer.cornerRadius = 8
                    view.frame = CGRect(x: 40, y: 100, width: 100, height: 100)
                    return view
                }()
                
                box2
                
            }
            
            revertButton
        }
    }
    
    @objc private func handleRevertTap() {
        view {
            box {
                textLabel
            }
        }
    }
    
    @objc private func handleViewTap() {
        box.disintegrate(maxTiles: 5000)
    }
}
