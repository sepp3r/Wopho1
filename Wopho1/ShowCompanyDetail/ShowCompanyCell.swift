//
//  ShowCompanyCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 26.07.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseDynamicLinks
import LinkPresentation
import CoreData
import MessageUI
import Network
import SDWebImage

class ShowCompanyCell: UICollectionViewCell, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {
    
    
    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 2.5
            scrollView.minimumZoomScale = 0.95
            scrollView.backgroundColor = .clear
            scrollView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favoritButton: UIButton!
    
    // MARK: - var||let
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    
    var coreDataArray = [CompanyUser]()
    var coreDataString = ""
    var saveCoreId = ""
    var buttonImage: UIImage!
    var mail = ""
    var postTextForMail = ""
    var postToShare = ""
    var imageString = ""
    var shareThisImage: UIImageView!
    var firebaseLink: URL?
    var mobile = ""
    var phone = ""
    var theInfo = ""
    var latitude = 0.0
    var longtitude = 0.0
    var companyName = ""
    var user = [UserModel]()
    var delegateShowDetail: ShowDetailVC!
    
    var datenZumTest = ""
    
    // MARK: - Database
    
    var detailPosts: PostModel? {
        didSet {
            loadCoreDate()
            guard let _deatilPosts = detailPosts else { return }
            updatePosts(post: _deatilPosts)
        }
    }
    
    func updatePosts(post: PostModel) {
        
        
        if let _uid = post.uid {
            companyInfo(userUid: _uid)
        }
        
        if let _postText = post.postText {
            postTextForMail = _postText
            postLabel.text = _postText
        }
        
        
        if let _postId = post.postId {
            postToShare = _postId
            saveCoreId = _postId
        }
        
        if let _imageString = post.imageUrl {
            imageString = _imageString
        }
        
        isNotLike()
        
        for index in coreDataArray {
            if index.postUid == post.postId {
                isLike()
            } else {
//                isNotLike()
            }
        }
        
        cellSetup()
        scrollView.delegate = self
        guard let url = URL(string: post.imageUrl!) else { return }
        postImage.sd_setImage(with: url) { _, _, _, _ in
        }
    }
    
    func companyInfo(userUid: String) {
        UserApi.shared.observeUser(uid: userUid) { [self] (data) in
            self.user.append(data)
            
            datenZumTest = data.uid!
            
            if let _mail = data.email {
                self.mail = _mail
                self.mailButtonEnabled()
            } else {
                self.mailButtonNotEnabled()
            }
            
            if let _phone = data.phone {
                self.phone = _phone
            } else {
                self.phoneNotEnabled()
            }
            
            if let _mobile = data.mobilePhone {
                self.mobile = _mobile
            } else {
                self.phoneNotEnabled()
            }
            
            if self.mobile == "" && self.phone == "" {
                self.phoneNotEnabled()
            } else {
                self.phoneEnabled()
            }
            
            if let _longitude = data.longitude, let _latitude = data.latitude {
                print("location daten long ->\(_longitude) && lat -> \(_latitude)")
                if _longitude == 0.0 || _latitude == 0.0 {
                    self.locationNotEnabled()
                } else {
                    self.longtitude = _longitude
                    self.latitude = _latitude
                    self.locationEnabled()
                }
            }
            
        }
    }
    
    // MARK: - CoreData Load - Save - Delete
    
    func loadCoreDate() {
        let company = CoreData.defaults.loadData()
        if let _company = company {
            self.coreDataArray = _company
        }
    }
    
    func saveCoreData() {
        if saveCoreId.count != 0 {
            let postId = CoreData.defaults.createData(_postUid: saveCoreId)
        } else {
            errorCoreData()
        }
    }
    
    func deleteCoreDate() {
        for i in coreDataArray {
            if i.postUid == saveCoreId {
                let card = i.self
                CoreData.defaults.context.delete(card)
                CoreData.defaults.saveContext()
                break
            }
        }
    }
    
    func errorCoreData() {
        let error = UIAlertController(title: "Hinweis", message: "Favorite konnte nicht gespeichert werden", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    }
    
    // MARK: - ScrollView Setup
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.zoomScale = 1
            self.zoomEnd()
            print("zoom___-Ende")
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomBegin()
        print("zoom___-Begin")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return postImage
    }
    
    // MARK: - Setup
    
    func buttonSetup() {
        let locationImage = UIImage(systemName: "location.fill")
        locationButton.setImage(locationImage, for: .normal)
        locationButton.imageView?.tintColor = .white
        
        let callImage = UIImage(systemName: "phone.fill")
        callButton.setImage(callImage, for: .normal)
        callButton.imageView?.tintColor = .white
        
        let mailImage = UIImage(systemName: "envelope")
        mailButton.setImage(mailImage, for: .normal)
        mailButton.imageView?.tintColor = .white
        
        let shareImage = UIImage(systemName: "square.and.arrow.up")
        shareButton.setImage(shareImage, for: .normal)
        shareButton.imageView?.tintColor = .white
        
        favoritButton.layer.cornerRadius = favoritButton.bounds.height/2
        favoritButton.clipsToBounds = true
    }
    
    func isLike() {
        favoritButton.backgroundColor = truqButtonColor
        favoritButton.setTitleColor(.white, for: .normal)
        favoritButton.setTitle("Favorit", for: .normal)
    }
    
    func isNotLike() {
        favoritButton.backgroundColor = .white
        favoritButton.setTitleColor(darkgrayButtonColor, for: .normal)
        favoritButton.setTitle("Favorit?", for: .normal)
    }
    
    func zoomEnd() {
        mailButton.alpha = 1.0
        callButton.alpha = 1.0
        locationButton.alpha = 1.0
        shareButton.alpha = 1.0
        favoritButton.alpha = 1.0
        postLabel.alpha = 1.0
//        postImage.alpha = 1.0
    }
    
    func zoomBegin() {
        mailButton.alpha = 0
        callButton.alpha = 0
        locationButton.alpha = 0
        shareButton.alpha = 0
        favoritButton.alpha = 0
        postLabel.alpha = 0
//        postImage.alpha = 0
    }
    
    func buttonAndLabelAlpaZero() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
            self.mailButton.alpha = 0
            self.callButton.alpha = 0
            self.locationButton.alpha = 0
            self.shareButton.alpha = 0
            self.favoritButton.alpha = 0
            self.postLabel.alpha = 0
        } completion: { _ in
            
        }
    }
    
    func buttonAndLabelAlphaOne() {
        self.mailButton.alpha = 1.0
        self.callButton.alpha = 1.0
        self.locationButton.alpha = 1.0
        self.shareButton.alpha = 1.0
        self.favoritButton.alpha = 1.0
        self.postLabel.alpha = 1.0
    }
    
    
    func cellSetup() {
        postLabel.adjustsFontSizeToFitWidth = true
        postImage.contentMode = .scaleAspectFit
        postImage.layer.cornerRadius = 10
        postImage.clipsToBounds = true
        postImage.layer.masksToBounds = true
        buttonSetup()
        zoomEnd()
    }
    
    func phoneNotEnabled() {
        callButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
        callButton.isEnabled = false
    }
    
    func phoneEnabled() {
        callButton.imageView?.tintColor = UIColor(white: 1.0, alpha: 1.0)
        callButton.isEnabled = true
    }
    
    func mailButtonNotEnabled() {
        mailButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
        mailButton.isEnabled = false
    }
    
    func mailButtonEnabled() {
        mailButton.imageView?.tintColor = UIColor(white: 1.0, alpha: 1.0)
        mailButton.isEnabled = true
    }
    
    func locationNotEnabled() {
        locationButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
        locationButton.isEnabled = false
    }
    
    func locationEnabled() {
        locationButton.imageView?.tintColor = UIColor(white: 1.0, alpha: 1.0)
        locationButton.isEnabled = true
    }
    
    func shareNotEnabled() {
        shareButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
        shareButton.isEnabled = false
    }
    
    func shareEnabled() {
        shareButton.imageView?.tintColor = UIColor(white: 1.0, alpha: 0.1)
        shareButton.isEnabled = true
    }
    
    // MARK: - Mail Setup
    
    func successMail() {
        let _mail = MFMailComposeViewController()
        _mail.mailComposeDelegate = self
        _mail.setToRecipients([mail])
        _mail.setSubject("Anfrage Iserat aus APP_NAME")
        _mail.setMessageBody("Hallo, ich interessiere mich für Ihren Post \(postTextForMail)", isHTML: false)
        self.delegateShowDetail.present(_mail, animated: true, completion: nil)
    }
    
    func errorMail() {
        let error = UIAlertController(title: "Mail Programm konnte nicht geöffnet werden", message: "Bitte prüfe deine Einstellungen!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegateShowDetail.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            self.delegateShowDetail.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.errorMail()
            self.delegateShowDetail.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.delegateShowDetail.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - Location Setup
    
    func successLocation() {
        guard let urlAppleMaps = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longtitude)") else { return }
        guard let urlGoogleMaps = URL(string: "comgooglemaps://?q=\(latitude),\(longtitude)&zoom=14&views=traffic") else { return }
        guard let webGoogleMaps = URL(string: "https://www.google.co.in/maps/dir/?q=\(latitude),\(longtitude)&zoom=14&views=traffic") else { return }
        guard let openGoogleMaps = URL(string: "comgooglemaps://") else { return }
        
        let alert = UIAlertController(title: "Karte wählen", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        
        if UIApplication.shared.canOpenURL(urlAppleMaps) {
            let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) { action in
                UIApplication.shared.open(urlAppleMaps)
            }
            alert.addAction(appleMaps)
        }
        
        if UIApplication.shared.canOpenURL(openGoogleMaps) {
            let googleMaps = UIAlertAction(title: "Google Maps", style: .default) { action in
                UIApplication.shared.open(urlGoogleMaps)
            }
            alert.addAction(googleMaps)
        } else {
            let webGoogleMaps = UIAlertAction(title: "Web Google Maps", style: .default) { action in
                UIApplication.shared.open(webGoogleMaps)
            }
            alert.addAction(webGoogleMaps)
        }
        self.delegateShowDetail.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Call Setup
    
    func isAnyPhone() {
        let _phone = phone.removeWhitespaces()
        let _mobile = mobile.removeWhitespaces()
        
        guard let urlLandline: NSURL = NSURL(string: "tel://\(_phone)") else { return }
        guard let urlMobile: NSURL = NSURL(string: "tel://\(_mobile)") else { return }
        
        let alert = UIAlertController(title: "Rufnummer wählen!", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        
        let firstNumber = UIAlertAction(title: "Festnetz", style: .default) { (action) in
            UIApplication.shared.open(urlLandline as URL, options: [:], completionHandler: nil)
        }
        
        let secondNumber = UIAlertAction(title: "Mobilfunk", style: .default) { (action) in
            UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
        }
        
        alert.addAction(firstNumber)
        alert.addAction(secondNumber)
        self.delegateShowDetail.present(alert, animated: true, completion: nil)
    }
    
    func isPhone() {
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func isMobile() {
        if let urlMobile = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(urlMobile) {
            UIApplication.shared.open(urlMobile, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Share Function
    func fixOrientation(image: UIImage, completion: @escaping (UIImage) -> ()) {
        
//        DispatchQueue.global(qos: .background).async {
//            
//        }
        
        if (image.imageOrientation == .up) {
            completion(image)
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("scheiß grafix \(normalizedImage)")
        completion(normalizedImage!)
        
    }
    
    func shareThisPost() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/posts"
        
        let postIdQueryItem = URLQueryItem(name: "postsID", value: postToShare)
        print("post geteilte id postIdToShare \(postToShare)")
        components.queryItems = [postIdQueryItem]
        
        guard let linkParameter = components.url else { return }
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://wopho1.page.link") else { return }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        
        shareLink.iOSParameters?.appStoreID = "962194608"
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.example.wopho1")
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "\(self.postTextForMail) -> App Wopho1"
        
        guard let urlImage = URL(string: imageString) else { return }
        firebaseLink = urlImage
        shareLink.socialMetaTagParameters?.imageURL = urlImage
        
        guard let longURL = shareLink.url else { return }
        print("The long dynamic is \(longURL.absoluteString)")
        shareLink.shorten { [weak self] (url, warnings, error) in
            if let error = error {
                print("error link \(error)")
                return
            }
            
            if let warnings = warnings {
                for warning in warnings {
                    print("WARNUNG URL \(warning)")
                }            }
            
            guard let url = url else { return }
            self?.showShareSheet(url: url)
        }
    }
    
    func showShareSheet(url: URL) {
        let promoText = "\(self.postTextForMail) -> App Wopho1"
        
        let urlSec = firebaseLink
        let data = try? Data(contentsOf: urlSec!)
        let image = UIImage(data: data!)
        fixOrientation(image: image!) { fixed in
            let metadata = LPLinkMetadata()
            metadata.imageProvider = NSItemProvider(object: fixed)
            metadata.originalURL = url
            metadata.title = promoText
            
            let metadataItemSouce = LinkPresentationItemSource(metaData: metadata)
            let activity = UIActivityViewController(activityItems: [metadataItemSouce], applicationActivities: [])
            self.delegateShowDetail.present(activity, animated: true, completion: nil)
//            UIView.animate(withDuration: 0.9) {
//                self.delegateShowDetail.view.alpha = 1.0
//                self.delegateShowDetail.view.isUserInteractionEnabled = true
//            }
        }
    }
    
    
    // MARK: - Action
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            self.successMail()
        } else {
            self.errorMail()
        }
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if phone.count != 0 && mobile.count != 0 {
            isAnyPhone()
        } else if phone.count != 0 {
            isPhone()
        } else if mobile.count != 0 {
            isMobile()
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        successLocation()
        print("Meine UID___ \(datenZumTest)")
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareThisPost()
//        UIView.animate(withDuration: 0.2) {
//            self.delegateShowDetail.view.alpha = 0.70
//            self.delegateShowDetail.view.isUserInteractionEnabled = false
//        }
    }
    
    @IBAction func postImageButtonTapped(_ sender: UIButton) {
        if favoritButton.backgroundColor == .white {
            isLike()
            saveCoreData()
            loadCoreDate()
        } else if favoritButton.backgroundColor == truqButtonColor {
            deleteCoreDate()
            isNotLike()
        }
    }
    
}
