//
//  PostConstraints.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 28.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

extension UIView {
    internal func addEdgeConstrainedSubview(view: UIView) {
        addSubview(view)
        edgePostConstrain(subView: view)
    }
    
    internal func edgePostConstrain(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: subView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: subView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)])
    }
}
