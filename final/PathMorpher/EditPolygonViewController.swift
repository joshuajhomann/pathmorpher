//
//  ViewController.swift
//  PolygonDrawing
//
//  Created by Joshua Homann on 1/13/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit

class EditPolygonViewController: UIViewController {
    @IBOutlet private var polygonView: PolygonView!
    @IBOutlet private var nameButton: UIButton!
    var polygon: Polygon!
    private var indexOfPointBeingDragged: Int?
    private let vertexRadius: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        polygonView.vertexRadius = vertexRadius
        polygon = polygon ?? Polygon(
            name: "Untitled",
            filename: UUID().uuidString + ".json",
            bounds: polygonView.bounds,
            vertices: [],
            isClosed: false
        )
        nameButton.setTitle(polygon.name, for: .normal)
        polygonView.polygon = polygon
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        polygon.bounds = polygonView.bounds
        polygonView.polygon = polygon
    }

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: polygonView)
        if let index = polygon.vertices.firstIndex(where: { $0.distance(to: tapPoint) <  vertexRadius }) {
            if index == 0 && polygon.isClosed {
                polygon.isClosed = false
            } else if index == 0 {
                polygon.isClosed = true
            } else {
                polygon.vertices.remove(at: index)
            }
        } else if !polygon.isClosed {
            polygon.vertices.append(tapPoint)
        }
        if polygon.vertices.count < 3 {
            polygon.isClosed = false
        }
        polygonView.polygon = polygon
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        let tapPoint = sender.location(in: polygonView)
        switch sender.state {
        case .began:
            guard let index = polygon.vertices.firstIndex(where: { $0.distance(to: tapPoint) <  vertexRadius * 1.5 }) else {
                return
            }
            indexOfPointBeingDragged = index
        case .changed:
            guard let indexOfPointBeingDragged = indexOfPointBeingDragged else {
                return
            }
            polygon.vertices[indexOfPointBeingDragged] = tapPoint
            polygonView.polygon = polygon
        case .ended, .cancelled:
            guard let indexOfPointBeingDragged = indexOfPointBeingDragged else {
                return
            }
            polygon.vertices[indexOfPointBeingDragged] = tapPoint
            self.indexOfPointBeingDragged = nil
            polygonView.polygon = polygon
        default:
            break
        }
    }

    @IBAction func editTitle(_ sender: UIButton) {
        let alert = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.text = polygon.name
        let submitAction = UIAlertAction(title: "ok", style: .default) { [unowned alert, unowned self] _ in
            self.polygon.name = alert.textFields?.first?.text ?? self.polygon.name
            sender.setTitle(self.polygon.name, for: .normal)
        }
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
}



