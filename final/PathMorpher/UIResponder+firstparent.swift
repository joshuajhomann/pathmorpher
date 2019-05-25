//
//  UIResponder+firstparent.swift
//  PathMorpher
//
//  Created by Joshua Homann on 5/24/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit

extension UIResponder {
    func firstParent<T: UIResponder>(ofType type: T.Type ) -> T? {
        return next as? T ?? next.flatMap { $0.firstParent(ofType: type) }
    }
}
