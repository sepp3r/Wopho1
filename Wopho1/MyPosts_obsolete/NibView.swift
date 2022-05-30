//
//  NibView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 17.11.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit

internal protocol NibView where Self: UIView {
    
}

extension NibView {
    func xibSetup() {
        backgroundColor = .clear
        let view = loadViewFromNib()
        addEdgeConstrainedSubView(view: view)
    }
    
    fileprivate func loadViewFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//        print("Wer ist mein UIView \(type(of: self))")
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("22222klappt nicht warum? \(type(of: self))")
            
        }
        print("view from XIB \(view.debugDescription)")
        return view
        
    }
}
