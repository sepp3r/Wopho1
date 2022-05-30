//
//  TextViewVC.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 02.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit

class TextViewVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var privacyPoliceTextView: UITextView!
    @IBOutlet weak var termsOfUseTextView: UITextView!
    @IBOutlet weak var imprintTextView: UITextView!
    
    
    // MARK: - var/let
    var headerText = ""
    
    override func viewDidLoad() {
        setup()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func setup() {
        headerLabel.text = headerText
        imprintTextView.isHidden = true
        privacyPoliceTextView.isHidden = true
        termsOfUseTextView.isHidden = true
        textViewCheck()
    }
    
    func textViewCheck() {
        if headerText == "Datenschutz" {
            privacyPoliceTextView.isHidden = false
        } else if headerText == "Nutzungsbedingungen" {
            termsOfUseTextView.isHidden = false
        } else if headerText == "Impressum" {
            imprintTextView.isHidden = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToPrivacyAndSupport", sender: self)
        imprintTextView.isHidden = true
        privacyPoliceTextView.isHidden = true
        termsOfUseTextView.isHidden = true
    }
    
    
    
}
