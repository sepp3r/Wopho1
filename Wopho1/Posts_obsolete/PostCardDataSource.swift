//
//  PostCardDataSource.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 27.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

protocol PostCardDataSource {
    func numberOfCardToShow() -> Int
    func card(forItemAtIndex index: Int) -> PostSwipeCard
    func emptyView() -> UIView?
}


protocol PostCardDelegate {
    
    func didTap(view: PostableView)
    
    func swipeEnd(on view: PostableView)
    
    func swipeBack(on view: PostableView)
}
