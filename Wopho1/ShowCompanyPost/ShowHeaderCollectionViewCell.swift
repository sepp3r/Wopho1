//
//  ShowHeaderCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 25.04.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI

protocol unwindFromShowHeader {
    func headerUnwind()
}

class ShowHeaderCollectionViewCell: UICollectionViewCell, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var streetImage: UIImageView!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
//    @IBOutlet weak var heightofHeader: NSLayoutConstraint!
    // header höhe -30 = 130
    
    
    
    // MARK: var / let
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupComanyInformation(user: _user)
        }
    }
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            setupPostInformation(post: _post)
        }
    }
    
    var delegate: ShowViewController!
    var delegeteSec: ShowViewController?
    var unwindDelegate: unwindFromShowHeader?
    
    var cellPhone: String = ""
    var mobilePhone: String = ""
    var receiver: String = ""
    var postText: String = ""
    
    func delegateFromUnwind() {
        unwindDelegate?.headerUnwind()
    }
    
    func setupComanyInformation(user: UserModel) {
        companyNameLabel.text = user.username
        
        if user.street != nil {
            streetLabel.text = user.street
        } else {
            streetLabel.isHidden = true
            streetImage.isHidden = true
        }
        
        if user.countryCode != "" {
            zipLabel.text = user.countryCode
        } else {
            zipLabel.isHidden = true
        }
        
        if user.city != "" {
            cityLabel.text = user.city
        } else {
            cityLabel.isHidden = true
        }
        
        if cityLabel.text == "" && self.zipLabel.text == "" {
            cityLabel.isHidden = true
            zipLabel.isHidden = true
            cityImage.isHidden = true
        }
        
        if user.textForEverything != "" {
            infoLabel.text = user.textForEverything
        } else {
            infoLabel.isHidden = true
            infoImage.isHidden = true
        }
        
        guard let url = URL(string: user.companyImageUrl!) else { return }
        companyImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    func setupPostInformation(post: PostModel) {
        postText = post.postText!
    }
    
    override func awakeFromNib() {
        headerSetup()
        delegeteSec?.moveHeaderDelegate = self
//        headerIsMoving()
    }
    
    
    
    
    // MARK: - Header Setup
    func headerSetup() {
        companyImageView.layer.cornerRadius = 10
        companyImageView.clipsToBounds = true
        companyNameLabel.tintColor = .white
        streetLabel.tintColor = .white
        zipLabel.tintColor = .white
        cityLabel.tintColor = .white
        infoLabel.tintColor = .white
        streetLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        zipLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        cityLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        infoLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
    }
    
    
    
    func streetSetup() {
        streetImage.image = UIImage(named: "streetNew")
    }
    
    func notZipInfo() {
        
    }
    
    func notCityInfo() {
        
    }
    
    
    func notInfoData() {
//        infoLabel.text = "Noch keine weiter Infos angegeben"
        infoLabel.isHidden = true
        infoImage.isHidden = true
        UIView.animate(withDuration: 0.2) {
//            self.heightofHeader.constant = 130
        }
    }
    
    func allInfoEmpty() {
        UIView.animate(withDuration: 0.2) {
//            self.heightofHeader.constant = 130
        }
        streetImage.image = UIImage(systemName: "infoNew")
        streetLabel.text = "Noch keine weiter Infos angegeben"
        cityImage.isHidden = true
        cityLabel.isHidden = true
        zipLabel.isHidden = true
        infoImage.isHidden = true
        infoLabel.isHidden = true
    }
    
    
    // MARK: - Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        delegateFromUnwind()
    }
    
    
    
    
    // MARK: - email Setup
    func showMailError() {
        let error = UIAlertController(title: "Email konnte nicht gesendet werden", message: "Bitte prüfen sie ihre Email-Einstellung", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            self.delegate.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.showMailError()
            self.delegate.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.delegate.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    @IBAction func cellPhoneButtonuuTapped(_ sender: UIButton) {
//        guard let number = URL(string: (user?.mobilePhone)!) else { return }
//        UIApplication.shared.open(number, options: [:], completionHandler: nil)
//        print("cellPhone test")
        
        // 1. funktionierenter TEST aber nur eine Nummer möglich
        
//        if let url = URL(string: "tel://\(cellPhone)"), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//
//        if let urlMobile = URL(string: "tel://\(mobilePhone)"), UIApplication.shared.canOpenURL(urlMobile) {
//            UIApplication.shared.open(urlMobile, options: [:], completionHandler: nil)
//        }
//        print("cellPhone test")
        
        // 3.
        
        print("kommt die nummer sauber an???  cellPhone \(cellPhone) &&& mobilePhone \(mobilePhone)")
        
        if cellPhone.count != 0 && mobilePhone.count != 0 {
            
            let phone = cellPhone.removeWhitspace()
            let phoneMobile = mobilePhone.removeWhitspace()
            
            print("cellPhone \(phone)")
            
            guard let urlLandline: NSURL = NSURL(string: "tel://\(phone)") else { return }
            guard let urlMobile: NSURL = NSURL(string: "tel://\(phoneMobile)") else { return }
            let alert = UIAlertController(title: "Möglichkeit wählen!", message: nil, preferredStyle: .actionSheet)
            let firstNumber = UIAlertAction(title: "Festnetz", style: .default) { (action) in
                UIApplication.shared.open(urlLandline as URL, options: [:], completionHandler: nil)
//                UIApplication.shared.canOpenURL(urlLandline as URL)
            }

            let secondNumber = UIAlertAction(title: "Mobilfunk", style: .default) { (action) in
                UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
//                UIApplication.shared.canOpenURL(urlMobile as URL)
            }

            alert.addAction(firstNumber)
            alert.addAction(secondNumber)
            self.delegate.present(alert, animated: true, completion: nil)
            print("How long did you come ")
        } else if cellPhone.count != 0 {
            print("wird CellPhone gewählt ??? ")
            if let url = URL(string: "tel://\(cellPhone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else if mobilePhone.count != 0 {
            print("wird MobilePhone gewählt ??? ")
            if let urlMobile = URL(string: "tel://\(mobilePhone)"), UIApplication.shared.canOpenURL(urlMobile) {
                UIApplication.shared.open(urlMobile, options: [:], completionHandler: nil)
            }
        } else {
            let error = UIAlertController(title: "Hinweis!", message: "Keine Nummer hinterlegt", preferredStyle: .alert)
            error.addAction(UIAlertAction(title: "zurück", style: .cancel, handler: nil))
            self.delegate.present(error, animated: true, completion: nil)
        }
        
        // 2. Version von Phone Call
//        let phone = "tel://"
//        let urlLandline:NSURL = NSURL(string: phone+cellPhone)!
//        let urlMobile:NSURL = NSURL(string: phone+mobilePhone)!
//
//        let alert = UIAlertController(title: "Nummer wählen", message: "Wähle mit wem du telefonieren willst", preferredStyle: .alert)
//
//        // Abweichung von Website Vorschlag -> secondNumber
//        let firstNumber = UIAlertAction(title: "Festnetz", style: .default) { (action) in
//            UIApplication.shared.open(urlLandline as URL as URL, options: [:], completionHandler: nil)
//        }
//
//        let secondNumber = UIAlertAction(title: "Mobilfunk", style: .default) { (action) in
//            UIApplication.shared.open(urlMobile as URL as URL, options: [:], completionHandler: nil)
//        }
//
//        alert.addAction(firstNumber)
//        alert.addAction(secondNumber)
//        self.delegate.present(alert, animated: true, completion: nil)
    }
    
//    func showMailError() {
//        let error = UIAlertController(title: "Email konnte nicht gesendet werden", message: "Bitte prüfen sie ihre Email-Einstellung", preferredStyle: .alert)
//        error.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
//        delegate.self?.present(error, animated: true, completion: nil)
//    }
    
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch result {
//        case MFMailComposeResult.cancelled:
//            self.delegate?.dismiss(animated: true, completion: nil)
//        case MFMailComposeResult.failed:
//            self.showMailError()
//            self.delegate?.dismiss(animated: true, completion: nil)
//        case MFMailComposeResult.sent:
//            self.delegate?.dismiss(animated: true, completion: nil)
//        default:
//            break
//        }
//    }
    
    
    @IBAction func mailButtonuuTapped(_ sender: UIButton) {
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients(["s.schmitt@sld-logistik.de"])
//            mail.setSubject("test Mail")
//            mail.setMessageBody("Nachricht sollte da stehen", isHTML: false)
//            self.delegate?.present(mail, animated: true, completion: nil)
//        } else {
//            self.showMailError()
//        }
        // Versuch über VC
//        delegate.mailSetup()
        
        // 3. Versuch
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([receiver])
            mail.setSubject("Anfrage Inserat bei App....")
            mail.setMessageBody("Ich interessiere mich für Ihren Post " + "\(postText)", isHTML: false)
            self.delegate.present(mail, animated: true, completion: nil)
        } else {
            self.showMailError()
        }
        
        print("test mail")
        print("postText where Toching",postText)
    }
}

extension String {
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitspace() -> String {
        return self.replace(string: " ", replacement: "")
    }

}

extension ShowHeaderCollectionViewCell: moveHeader {
    func headerIsMoving() {
        print("funktioniert das ---- 1HEADER")
    }
}
