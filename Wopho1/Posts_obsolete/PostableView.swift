//
//  PostableView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 27.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

class PostableView: UIView {
    
    var delegate : PostCardDelegate?
    var divisor : CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("wie oft kommst es ----1")
        panGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("wie oft kommst es ----")
        panGesture()
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))
//    }
    
    
    
    func panGesture() {
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = false
        
        print("wie oft kommst es")
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let card = sender.view as! PostableView
        
        
        let point = sender.translation(in: self)
        print("ende pan 3.02 \(card.superview)")
//        print("ende pan 3.02 \(sender.velocity(in: card))")
        print("ende pan 3.00First \(point.debugDescription)")
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
//        print("frame of Parent Container ----- \(centerOfParentContainer)")
//        print("PostableView ------ \(card.bounds)")
        
//        card.isMultipleTouchEnabled = true
        
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        divisor = (UIScreen.main.bounds.width / 2) / 0.61
        
        print("PostAbleView ///// ---- \(card)")
        
        switch sender.state {
        case .ended:
//            print("if card.center.x > 200 ---- \(card.center.x)")
            if (card.center.x) > 200 || (card.center.x) < 120 {
                delegate?.swipeEnd(on: card)
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                    print("ende pan 1")
                }
                return
            } else if card.center.x < -65 {
//                print("if card.center.x -65 ---- \(card.center.x)")
                delegate?.swipeEnd(on: card)
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                    print("ende pan 2")
                }
                return
            }
            UIView.animate(withDuration: 0.3) { [self] in
                print("ende pan 3.1 \(point.debugDescription)")
                
//                card.transform = CGAffineTransform.identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                card.transform = .identity
                
                
//                card.transform = CGAffineTransform.identity
//                card.contentScaleFactor.isNormal
                
//                self.layoutIfNeeded()
//                card.removeFromSuperview()
//                DispatchQueue.main.async {
////                    self.layoutIfNeeded()
////                    card.contentMode = .center
////                    card.layer.masksToBounds = true
//                    card.gestureRecognizers?.removeAll()
//                }
//                for gesture in card.gestureRecognizers ?? [] {
////                    card.removeGestureRecognizer(gesture)
//
////                    gesture.delaysTouchesEnded = true
//                    print("was ist das \(gesture)")
//                }
                
//                card.gestureRecognizers = nil
                print("ende pan 3.00e \(card.superview?.setNeedsLayout())")
                
                
//                print("gib dich zu erkennen------------")
            }
            return
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            if card.frame.width == 285 && card.frame.height == 475 {
                delegate?.swipeBack(on: card)
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    print("ende pan 4")
                }
            }
            
        default:
            print("ende pan 5")
            break
        }
        
        if sender.numberOfTouches == 1 {
            
        }
        
        
    }
    
}
