//
//  PrivacAndSupportVCy.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 02.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import MessageUI
import Network



class PrivacyAndSupportVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var privacyAndSupportTableView: UITableView!
    
    
    // MARK: - var/let
    let array = ["Datenschutz","Kontaktiere uns per Mail","Nutzungsbedingungen","Impressum"]
    var tappedCellText = ""
    
    override func viewDidLoad() {
        privacyAndSupportTableView.dataSource = self
        
//        privacyAndSupportTableView.rowHeight = UITableView.automaticDimension
//        privacyAndSupportTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTextViewVC" {
            
//            let barViewController = segue.destination as! UITabBarController
//            let nav = barViewController.viewControllers![3] as! UINavigationController
//            let destinationVC = nav.topViewController as! TextViewVC
//            destinationVC.headerText = tappedCellText
            
            
            
            
            
            let _textViewVC = segue.destination as! TextViewVC

            _textViewVC.headerText = tappedCellText
            
        }
    }
    
    // MARK: - Action
    @IBAction func unwindToPrivacyAndSupport(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
}

extension PrivacyAndSupportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyAndSupportCell", for: indexPath) as? PrivacyAndSupportTableViewCell {
            
            
            cell.cellLabel.text = array[indexPath.row]
            cell.backgroundColor = .clear
            cell.delegate = self
            cell.delegateCell = self
            
            return cell
        }
        return UITableViewCell()
        
    }
}

extension PrivacyAndSupportVC: showCellDelegate {
    func tappedCell(cellText: String) {
        tappedCellText = cellText
        performSegue(withIdentifier: "showTextViewVC", sender: nil)
    }
}
