//
//  PolygonListTableViewCell.swift
//  PathMorpher
//
//  Created by Joshua Homann on 5/24/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit

class PolygonListTableViewCell: UITableViewCell {
    @IBOutlet private var polygonView: PolygonView!
    @IBOutlet private var titleLabel: UILabel!

    func configure(with polygon: Polygon) {
        titleLabel.text = polygon.name
        polygonView.polygon = polygon
    }

}
