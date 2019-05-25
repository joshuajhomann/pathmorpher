//
//  MorphViewController.swift
//  PathMorpher
//
//  Created by Joshua Homann on 5/24/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit

class MorphViewController: UIViewController {
    var paths: [CGPath] = []
    private let shapeLayer = CAShapeLayer()
    private var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeLayer.fillRule = .evenOdd
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.path = paths.first
        view.layer.addSublayer(shapeLayer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if paths.count > 1 {
            animate()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeLayer.frame = view.bounds
    }

    private func animate() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.index += 1
            self.index %= self.paths.count
            self.shapeLayer.removeAllAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.animate()
            }
        }
        let morphAnimation = CAKeyframeAnimation(keyPath: "path")
        morphAnimation.duration = 1
        morphAnimation.values = [paths[index], paths[(index+1) % paths.count]]
        shapeLayer.add(morphAnimation, forKey: "morph")
        CATransaction.commit()
        shapeLayer.path = paths[(index+1) % paths.count]
    }
}
