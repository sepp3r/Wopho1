//
//  Constraints.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.01.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

extension UIView {
    internal func addEdgeConstrainedSubView(view: UIView) {
        addSubview(view)
        edgeConstrain(subView: view)
    }
    
    internal func edgeConstrain(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: subView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: subView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)])
        
    }
}
