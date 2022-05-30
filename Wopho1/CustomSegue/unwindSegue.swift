//
//  unwindSegue.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 17.03.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//
import Foundation
import UIKit

class UnwindSegue: UIStoryboardSegue {
    
    
    override func perform() {
//        var sourceView = self.source.view as UIView?
//        var destiView = self.destination.view as UIView?
//
//        let screenHeigt = UIScreen.main.bounds.size.height
//
//        let window = UIApplication.shared.keyWindow
//        window?.insertSubview(destiView!, aboveSubview: sourceView!)
//
//        UIView.animate(withDuration: 0.4) {
//            destiView?.frame = CGRect.offsetBy(destiView!.frame, 0.0, screenHeigt)
//        } completion: { (Finished) in
//
//        }
        
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/2, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        } completion: { (finished) in
//            src.navigationController!.present(dst, animated: false, completion: nil)
//            src.parent?.present(dst, animated: false, completion: nil)
//            src.navigationController?.pushViewController(dst, animated: false)
//            src.navigationController?.dismiss(animated: false, completion: nil)
            print("funtzt die Klasse")
//            src.navigationController?.popToViewController(dst, animated: false)
            src.navigationController?.present(dst, animated: false, completion: nil)
//            src.present(dst, animated: false, completion: nil)
        }


    }
    
    
}
