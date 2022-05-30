//
//  PostCardViewDelegate.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 29.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import Foundation

protocol PostCardViewDelegate: class {
    func didSelect(card: SwipePostViewCard, atIndex index: Int)
}
