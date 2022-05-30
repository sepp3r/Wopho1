//
//  PostNipView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 27.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

internal protocol PostNipView where Self: UIView {
    
}

extension PostNipView {
    func xibSetup() {
        backgroundColor = .clear
        let view = loadViewFromNib()
        addEdgeConstrainedSubView(view: view)
    }
    
    fileprivate func loadViewFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError()
            
        }
        print("view from XIB \(view.debugDescription)")
        return view
    }
}
