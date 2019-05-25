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
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let polygonBounds = polygon?.bounds ?? bounds
        let scale = min(bounds.width/polygonBounds.width, bounds.height/polygonBounds.height)
        UIGraphicsGetCurrentContext()?.scaleBy(x: scale, y: scale)
        if shouldDrawGrid {
            let path = UIBezierPath()
            stride(from: 0, to: bounds.width, by: gridSpacing).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: bounds.size.height))
            }
            stride(from: 0, to: bounds.height, by: gridSpacing).forEach { y in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: bounds.size.width, y: y))
            }
            path.lineWidth = 0.25
            path.stroke()
            gridColor.setStroke()
        }
        guard let polygon = polygon,
              !polygon.vertices.isEmpty else {
            return
        }

        let path = polygon.path


        polygonColor.setFill()
        if polygon.isClosed {
            path.fill()
        }

        polygonColor.setStroke()
        path.lineWidth = polygonStrokeWidth
        path.stroke()

        vertextColor.setFill()
        let vertexCenteredRectangles = polygon.vertices.map { point in
            CGRect(x: point.x - vertexRadius, y: point.y - vertexRadius, width: vertexRadius * 2, height: vertexRadius * 2)
        }
        vertexCenteredRectangles.dropFirst().forEach { UIBezierPath(ovalIn: $0).fill()}
        firstVertextColor.setFill()
        UIBezierPath(ovalIn: vertexCenteredRectangles[0]).fill()
    }
}
