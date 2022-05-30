//
//  SwipePostViewCard.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 28.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

class SwipePostViewCard: PostableView, PostNipView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
}
