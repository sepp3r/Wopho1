//
//  SwipeCardViewDelegate.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.12.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation

protocol SwipeCardViewDelegate: class {
    func didSelect(card: SwipeCardViewCard, atIndex index: Int)
}
