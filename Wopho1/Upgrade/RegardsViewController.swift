//
//  RegardsViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 03.01.22.
//  Copyright © 2022 Sebastian Schmitt. All rights reserved.
//

import UIKit

class RegardsViewController: UIViewController {

    // MARK: - Layout
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var fireworkImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - var / let
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        animationFirework()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setup() {
        continueButton.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        continueButton.layer.cornerRadius = 5
        continueButton.tintColor = .lightGray
        continueButton.isEnabled = false
//        saveThePayed()
    }
    
//    func saveThePayed() {
//        let pay = CoreData.defaults.payedInfo(_payed: true)
//    }
    
    func animationFirework() {
        self.fireworkOne()
        self.fireworkTwo()
        self.fireworkThree()
        self.fireworkFour()
        self.fireworkFive()
        self.fireworkSix()
        self.fireworkOver()
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            UIView.animate(withDuration: 0.3, delay: 9.5, options: .curveLinear) {
//                self.fireworkOne()
//            } completion: { (end) in
//                UIView.animate(withDuration: 0.3, delay: 9.5, options: .curveLinear) {
//                    self.fireworkTwo()
//                } completion: { (end) in
//                    UIView.animate(withDuration: 0.3, delay: 9.5, options: .curveLinear) {
//                        self.fireworkThree()
//                    } completion: { (end) in
//                        UIView.animate(withDuration: 0.3, delay: 9.5, options: .curveLinear) {
//                            self.fireworkFour()
//                        } completion: { (end) in
//                            UIView.animate(withDuration: 0.3, delay: 9.5, options: .curveLinear) {
//                                self.fireworkFive()
//                            } completion: { (end) in
//                                UIView.animate(withDuration: 0.3, delay: 9.5, options: .curveLinear) {
//                                    self.fireworkSix()
//                                } completion: { (end) in
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func fireworkOne() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let image = UIImage(named: "firework1")
            self.fireworkImage.image = image
        }
    }
    
    func fireworkTwo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let image = UIImage(named: "firework2")
            self.fireworkImage.image = image
        }
    }
    
    func fireworkThree() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let image = UIImage(named: "firework3")
            self.fireworkImage.image = image
        }
    }
    
    func fireworkFour() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let image = UIImage(named: "firework4")
            self.fireworkImage.image = image
        }
    }
    
    func fireworkFive() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let image = UIImage(named: "firework5")
            self.fireworkImage.image = image
            UIView.animate(withDuration: 0.5) {
                self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = true
                self.welcomeLabel.frame.origin.y -= 100
                self.welcomeLabel.isHidden = false
            }
        }
    }
    
    func fireworkSix() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.9) {
            let image = UIImage(named: "firework6")
            self.fireworkImage.image = image
            self.doneButtonSetup()
        }
    }
    
    func fireworkOver() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            self.fireworkImage.image = nil
        }
    }
    
    
    func doneButtonSetup() {
        continueButton.backgroundColor = truqButtonColor
        continueButton.layer.cornerRadius = 5
        continueButton.tintColor = .white
        continueButton.isEnabled = true
    }
    
    
    // MARK: - Action
    @IBAction func continueButtonTapped(_ sender: UIButton) {
    }
    

}
