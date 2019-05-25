//
//  PolygonView.swift
//  PolygonDrawing
//
//  Created by Joshua Homann on 1/13/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit

@IBDesignable class PolygonView: UIView {
    @IBInspectable var gridSpacing: CGFloat = 24
    @IBInspectable var gridColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    @IBInspectable var polygonColor: UIColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).withAlphaComponent(0.75)
    @IBInspectable var vertextColor: UIColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    @IBInspectable var firstVertextColor: UIColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    @IBInspectable var polygonStrokeWidth: CGFloat = 2
    @IBInspectable var vertexRadius: CGFloat = 12
    @IBInspectable var shouldDrawGrid: Bool = true
    var polygon: Polygon? {
        didSet {

        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
