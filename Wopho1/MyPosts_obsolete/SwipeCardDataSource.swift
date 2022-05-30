//
//  SwipeCardDataSource.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 22.10.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit

protocol SwipeCardDataSource {
    func numberOfCardToShow() -> Int
    func card(forItemAtIndex index: Int) -> PostSwipeCardView
    func emptyView() -> UIView?
}

protocol SwipeCardDelegate {
    
    func didTap(view: SwipeableView)
    
    func swipeEnd(on view: SwipeableView)
    
    func deleteView(by view: SwipeableView)
}
