//
//  SwipeCardViewCard.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 19.11.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit

class SwipeCardViewCard: SwipeableView, NibView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
}
