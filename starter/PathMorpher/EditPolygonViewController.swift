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
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
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



