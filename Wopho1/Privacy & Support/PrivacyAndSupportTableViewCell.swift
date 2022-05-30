//
//  PrivacyAndSupportTableViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 02.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import MessageUI

protocol showCellDelegate {
    func tappedCell(cellText: String)
}

class PrivacyAndSupportTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    // MARK: - outlet
    @IBOutlet weak var cellLabel: UILabel!
    
    // MARK: - var/let
    var delegateCell: PrivacyAndSupportVC!
    var mail = "appMail@support.de"
    
    override func layoutSubviews() {
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCell))
        cellLabel.addGestureRecognizer(tapGesture)
        cellLabel.isUserInteractionEnabled = true
    }
    
    var delegate: showCellDelegate?
    
    @objc func handleCell() {
        guard let text = cellLabel.text else { return }
        print("text welcher _ \(text)")
        if text == "Kontaktiere uns per Mail" {
            if MFMailComposeViewController.canSendMail() {
                self.successMail()
            } else {
                self.errorMail()
            }
        } else {
            delegate?.tappedCell(cellText: text)
        }
        
    }
    
    // MARK: - Setup
    func setup() {
        cellLabel.textColor = .white
        cellLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
    }
    
    // MARK: - Mail Setup
    
    func successMail() {
        let _mail = MFMailComposeViewController()
        _mail.mailComposeDelegate = self
        _mail.setToRecipients([mail])
        _mail.setSubject("")
        _mail.setMessageBody("", isHTML: false)
        self.delegateCell.present(_mail, animated: true, completion: nil)
    }
    
    func errorMail() {
        let error = UIAlertController(title: "Mail Programm konnte nicht geöffnet werden", message: "Bitte prüfe deine Einstellungen!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegateCell.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            self.delegateCell.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.errorMail()
            self.delegateCell.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.delegateCell.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
}
