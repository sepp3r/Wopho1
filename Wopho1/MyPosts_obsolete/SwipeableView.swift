//
//  SwipeableView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 19.11.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit

class SwipeableView: UIView {
    
    var delegate : SwipeCardDelegate?
    var divisor : CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        panGesture()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        panGesture()
    }
    
    
    func panGesture() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))
    }
    
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let card = sender.view as! SwipeableView // doch PostSwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)

        
        divisor = (UIScreen.main.bounds.width / 2) / 0.61
        
        switch sender.state {
        case .ended:
            print("if card.center.x > 200 ---- \(card.center.x)")
            if (card.center.x) > 200 || (card.center.x) < 120 {
                delegate?.swipeEnd(on: card)
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
                
            } else if card.center.x < -65 {
                print("if card.center.x -65 ---- \(card.center.x)")
                delegate?.swipeEnd(on: card)
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.3) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotaion = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotaion)

        default:
            break
        }
        
        
    }
    
}
