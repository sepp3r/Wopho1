//
//  SearchResultCVC.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 07.05.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import FirebaseDatabase
import FirebaseDynamicLinks
import LinkPresentation
import Network
import MessageUI


protocol zoomNotification {
    func zoom()
}

protocol zoomNotifyEnd {
    func zoomEnding()
}

protocol tappedImage {
    func tapping(userUid: String, postText: String, postId: String)
}

class SearchResultCVC: UICollectionViewCell, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - Layout
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 2.5
            scrollView.minimumZoomScale = 0.95
            scrollView.backgroundColor = .clear
            scrollView.layer.cornerRadius = 5
        }
    }
    
    // MARK: - var || let
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var initialCenter = CGPoint()
    var delegateZoom: zoomNotification?
    var delegateEndOfZomm: zoomNotifyEnd?
    var tappedImageDelegate: tappedImage?
    var delegateSearchResultVC: SearchResultViewController!
    var postCheckId = ""
    var company: [String] = []
    var companyArray = [CompanyUser]()
    var saveIdForCoreData = ""
    
    var postIdToShare = ""
    var shareThisImage: UIImageView!
    var imageString = ""
    var firebaseLink: URL?
    
    var shareImageTest: UIImage?
    
    var idFromCompany = ""
    
    var mail = ""
    var postTextForMail = ""
    var mobile = ""
    var phone = ""
    var theInformation = ""
    var latitude = 0.0
    var longitude = 0.0
    var companyName = ""
    
    
    var user = [UserModel]()
    
    
    var post: PostModel? {
        didSet {
            loadCoreData()
            guard let _post = post else { return }
            updateCell(post: _post)
            
        }
    }
    
    override func layoutSubviews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTappedImage))
        cellImage.addGestureRecognizer(tapGesture)
        
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomBegin()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.zoomScale = 1
            self.zoomEnd()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cellImage
    }
    
    
    
    
//    var company: UserModel? {
//        didSet {
//            guard let _company = company else { return }
//            updateCompany(company: _company)
//        }
//    }
    // MARK: - Segue TapGesture
    @objc func handleTappedImage() {
        let _userUid = idFromCompany
        let _postText = postTextForMail
        let _postId = postIdToShare
            tappedImageDelegate?.tapping(userUid: _userUid, postText: _postText, postId: _postId)
    }
    
    // MARK: - CoreData Load - Save - Delete
    func loadCoreData() {
        let company = CoreData.defaults.loadData()
        if let _company = company {
            self.companyArray = _company
        }
    }
    
    func saveCoreData() {
        
        if saveIdForCoreData.count != 0 {
            let postId = CoreData.defaults.createData(_postUid: saveIdForCoreData)
        } else {
            errorCoreData()
        }
        
    }
    
    func deleteCoreData() {
        for i in companyArray {
            if i.postUid == saveIdForCoreData {
                let card = i.self
                CoreData.defaults.context.delete(card)
                CoreData.defaults.saveContext()
                break
            }
        }
    }
    
    func errorCoreData() {
        let error = UIAlertController(title: "Hinweis", message: "Favorite konnte nicht gespeichert werden!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
    }
    
    // MARK: - Pan and Pinch
    
    @objc func pinchGesture(gesturePinch: UIPinchGestureRecognizer) {
        if gesturePinch.state == .recognized {
            UIView.animate(withDuration: 0.2) {
                self.cellImage.transform = CGAffineTransform.identity
                self.zoomEnd()
                self.zoomInfoEnd()
                
            }
        } else if cellImage.transform.a >= 1.0 && cellImage.transform.d >= 1.0 && cellImage.transform.a <= 6.0 && cellImage.transform.d <= 6.0 {
            self.zoomBegin()
            self.zoomInfo()
            gesturePinch.view?.transform = (gesturePinch.view?.transform.scaledBy(x: gesturePinch.scale, y: gesturePinch.scale))!
            gesturePinch.scale = 1.0
        }
        
    }
    
    
    @objc func panGesture(gesturePan: UIPanGestureRecognizer) {
        let piece = gesturePan.view!
        let translation = gesturePan.translation(in: piece.superview)
        
        if gesturePan.state == .began {
            self.initialCenter = piece.center
        }
        if gesturePan.state == .ended {
            piece.center = initialCenter
        } else if gesturePan.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
        
    }
    
    
    
    @objc func zoomInfo() {
        delegateZoom?.zoom()
    }
    
    @objc func zoomInfoEnd() {
        delegateEndOfZomm?.zoomEnding()
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    // MARK: - Setup
    func updateCell(post: PostModel){
        
        print("cardFrameHigh --------!!!!!!::::: cell Image \(cellImage.frame)")
        postLabel.text = post.postText
        postIdToShare = post.postId!
        postTextForMail = post.postText!
        saveIdForCoreData = post.postId!
        companyInformation(companyId: post.uid!)
//        imageString = post.imageUrl!
        
        if let _imageString = post.imageUrl {
            imageString = _imageString
        }
        
        isNotLike()
        
        for index in companyArray {
            
            if index.postUid == post.postId {
//                print("likeFunc_text -> compare -> compArray -> \(index.postUid) && postId -> \(post.postId)")
                isLike()
            } else if index.postUid != post.postId {
//                isNotLike()
//                print("likeFunc_text -> IS NOT LIKE")
            }
        }
    
        cellSetup()
        guard let url = URL(string: post.imageUrl!) else { return }
        cellImage.sd_setImage(with: url) { _, _, _, _ in
        }
        
        scrollView.delegate = self
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesturePinch:)))
//        cellImage.addGestureRecognizer(pinchGesture)
//        pinchGesture.delegate = self
//
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesturePan:)))
//        cellImage.addGestureRecognizer(panGesture)
//        panGesture.maximumNumberOfTouches = 2
//        panGesture.minimumNumberOfTouches = 2
        cellImage.isUserInteractionEnabled = true
        cellImage.isMultipleTouchEnabled = true
    }
    
    func companyInformation(companyId: String) {
        UserApi.shared.observeUser(uid: companyId) { [self] (data) in
            self.user.append(data)
            
            idFromCompany = data.uid!
            print("brauche die Company Id \(idFromCompany)")
            
            if let _mail = data.email {
                self.mail = _mail
                self.mailButtonEnabled()
            } else {
                self.mailButtonNotEnabled()
            }
            
            if let _phone = data.phone {
                self.phone = _phone
            }
            
            if let _mobile = data.mobilePhone {
                self.mobile = _mobile
            }
            
//            if let _theInformation = data.textForEverything {
//                self.theInformation = _theInformation
//            }
            
            if self.mobile == "" && self.phone == "" {
                self.phoneButtonNotEnabled()
            } else {
                self.phoneButtonEnabled()
            }
            
            if let _longitude = data.longitude, let _latitude = data.latitude {
                if _longitude == 0.0 || _latitude == 0.0 {
                    self.locationButtonNotEnabled()
                } else {
                    self.longitude = _longitude
                    self.latitude = _latitude
                    self.locationButtonEnabled()
                }
            }
        }
    }
    
//    func updateCompany(company: UserModel) {
//
//    }
    
    func cellSetup() {
        postLabel.adjustsFontSizeToFitWidth = true
        cellImage.contentMode = .scaleAspectFit
        cellImage.layer.cornerRadius = 10
        cellImage.clipsToBounds = true
        cellImage.layer.masksToBounds = true
        setupButton()
    }
    
    
    
    func zoomBegin() {
        mailButton.alpha = 0
        callButton.alpha = 0
        navButton.alpha = 0
        shareButton.alpha = 0
        likeButton.alpha = 0
        postLabel.alpha = 0
        postLabel.alpha = 0
    }
    
    func zoomEnd() {
        mailButton.alpha = 1.0
        callButton.alpha = 1.0
        navButton.alpha = 1.0
        shareButton.alpha = 1.0
        likeButton.alpha = 1.0
        postLabel.alpha = 1.0
        postLabel.alpha = 1.0
    }
    
    func buttonAndLabelAlpaZero() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
            self.mailButton.alpha = 0
            self.callButton.alpha = 0
            self.navButton.alpha = 0
            self.shareButton.alpha = 0
            self.likeButton.alpha = 0
            self.postLabel.alpha = 0
        } completion: { _ in
            
        }
    }
    
    func buttonAndLabelAlphaOne() {
        self.mailButton.alpha = 1.0
        self.callButton.alpha = 1.0
        self.navButton.alpha = 1.0
        self.shareButton.alpha = 1.0
        self.likeButton.alpha = 1.0
        self.postLabel.alpha = 1.0
    }
    
    func setupButton() {
        let locationImage = UIImage(systemName: "location.fill")
        navButton.setImage(locationImage, for: .normal)
        navButton.imageView?.tintColor = .white
        
        let callImage = UIImage(systemName: "phone.fill")
        callButton.setImage(callImage, for: .normal)
        callButton.imageView?.tintColor = .white
        
        let mailImage = UIImage(systemName: "envelope")
        mailButton.setImage(mailImage, for: .normal)
        mailButton.imageView?.tintColor = .white
        
        let shareImage = UIImage(systemName: "square.and.arrow.up")
        shareButton.setImage(shareImage, for: .normal)
        shareButton.imageView?.tintColor = .white
        
//        let likeImage = UIImage(systemName: "star")
//        likeButton.setImage(likeImage, for: .normal)
//        likeButton.imageView?.tintColor = .white
        
        likeButton.layer.cornerRadius = likeButton.bounds.height/2
//        likeButton.backgroundColor = .white
        likeButton.clipsToBounds = true
//        likeButton.setTitleColor(darkgrayButtonColor, for: .normal)
        
    }
    
    
    func buttonStyleRound() {
//        navButton.setTitle("", for: .normal)
//        navButton.titleLabel?.removeFromSuperview()
//        let locationImage = UIImage(systemName: "location.fill")
//        navButton.setImage(locationImage, for: .normal)
//        navButton.layer.cornerRadius = navButton.bounds.width/2
//        navButton.imageView?.tintColor = truqButtonColor
//        navButton.backgroundColor = .white
//        navButton.layer.borderWidth = 2
//        navButton.tintColor = truqButtonColor
//        navButton.layer.borderColor = navButton.tintColor.cgColor
        navButton.isHidden = true
        callButton.isHidden = true
        mailButton.isHidden = true
        shareButton.isHidden = true
        likeButton.isHidden = true
    }
    
    func buttonDefault() {
        navButton.isHidden = false
        callButton.isHidden = false
        mailButton.isHidden = false
        shareButton.isHidden = false
        likeButton.isHidden = false
    }
    
    func isLike() {
        likeButton.backgroundColor = truqButtonColor
//        likeButton.tintColor = .white
        likeButton.setTitleColor(.white, for: .normal)
        likeButton.setTitle("Favorit", for: .normal)
    }
    
    func isNotLike() {
        likeButton.backgroundColor = .white
//        likeButton.tintColor = darkgrayButtonColor
        likeButton.setTitleColor(darkgrayButtonColor, for: .normal)
        likeButton.setTitle("Favorit?", for: .normal)
    }
    
    func mailButtonEnabled() {
        mailButton.isEnabled = true
        mailButton.imageView?.tintColor = .white
    }
    
    func phoneButtonEnabled() {
        callButton.isEnabled = true
        callButton.imageView?.tintColor = .white
    }
    
    func locationButtonEnabled () {
        callButton.isEnabled = true
        navButton.imageView?.tintColor = .white
    }
    
    func mailButtonNotEnabled() {
        mailButton.isEnabled = false
        mailButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
    }
    
    func phoneButtonNotEnabled() {
        callButton.isEnabled = false
        callButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
    }
    
    func locationButtonNotEnabled () {
        navButton.isEnabled = false
        navButton.imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
    }
    
    // MARK: Button Func Setup
    
    func successMail() {
        let _mail = MFMailComposeViewController()
        _mail.mailComposeDelegate = self
        _mail.setToRecipients([mail])
        _mail.setSubject("Anfrage Iserat aus APP_NAME")
        _mail.setMessageBody("Hallo, ich interessiere mich für Ihren Post \(postTextForMail)", isHTML: false)
        self.delegateSearchResultVC.present(_mail, animated: true, completion: nil)
    }
    
    func errorMail() {
        let error = UIAlertController(title: "Mail Programm konnte nicht geöffnet werden", message: "Bitte prüfe deine Einstellungen!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegateSearchResultVC.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            self.delegateSearchResultVC.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.errorMail()
            self.delegateSearchResultVC.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.delegateSearchResultVC.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - Location Setup
    
    func successLocation() {
        guard let urlAppleMaps = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)") else { return }
        guard let urlGoogleMaps = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&zoom=14&views=traffic") else { return }
        guard let webGoogleMaps = URL(string: "https://www.google.co.in/maps/dir/?q=\(latitude),\(longitude)&zoom=14&views=traffic") else { return }
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
        self.delegateSearchResultVC.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Phone Setup
    
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
        self.delegateSearchResultVC.present(alert, animated: true, completion: nil)
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
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        completion(normalizedImage)
        
    }
    
    func shareThisPost() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/posts"
        
        let postIdQueryItem = URLQueryItem(name: "postsID", value: postIdToShare)
        print("post geteilte id postIdToShare \(postIdToShare)")
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
            //metadata.imageProvider?.preferredPresentationStyle = .unspecified
            metadata.originalURL = url
            metadata.title = promoText
            
            
            
            let metadataItemSouce = LinkPresentationItemSource(metaData: metadata)
            
            let activity = UIActivityViewController(activityItems: [metadataItemSouce], applicationActivities: [])
            self.delegateSearchResultVC.present(activity, animated: true, completion: nil)
            UIView.animate(withDuration: 0.9) {
                self.delegateSearchResultVC.view.alpha = 1.0
                self.delegateSearchResultVC.view.isUserInteractionEnabled = true
            }
        }
        //let secImage = UIImage(cgImage: (image?.cgImage)!, scale: image!.scale, orientation: .up)
        //secImage.withRenderingMode(.alwaysTemplate)
        
        //self.shareImageTest = fix
        //image?.imageOrientation = .up
        print("alter bewegt sich da was \(image)")
        
    }
    
    
    
//    func shareThisPost() {
//        let sharePost = postTextForMail
//        let url: NSURL = NSURL(string: "https://testflight.apple.com/join/un5pvmvk")!
//        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [sharePost, url, shareThisImage as Any], applicationActivities: nil)
//
//        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
//        activityVC.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
//        activityVC.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
//        activityVC.excludedActivityTypes = [UIActivity.ActivityType.postToTwitter]
//        activityVC.isModalInPresentation = true
//        self.delegateSearchResultVC.present(activityVC, animated: true, completion: nil)
//
//    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func roundMailButtonTapped(_ sender: UIButton) {
        buttonDefault()
    }
    
    
    @IBAction func mailButtonTapped(_ sender: UIButton) {
//        buttonStyleRound()
        if MFMailComposeViewController.canSendMail() {
            self.successMail()
        } else {
            self.errorMail()
        }
        
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if phone.count != 0 && mobile.count != 0 {
            isAnyPhone()
            print("welches Telefon -> Beide")
        } else if phone.count != 0 {
            isPhone()
            print("welches Telefon -> Festnetz")
        } else if mobile.count != 0 {
            isMobile()
            print("welches Telefon -> Mobile")
        }
    }
    
    @IBAction func navButtonTapped(_ sender: UIButton) {
        successLocation()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareThisPost()
        UIView.animate(withDuration: 0.1) {
            self.delegateSearchResultVC.view.alpha = 0.75
            self.delegateSearchResultVC.view.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if likeButton.backgroundColor == .white {
            print("likeFunc_text -> Load Start -> \(companyArray.count)")
            isLike()
            saveCoreData()
            loadCoreData()
            print("likeFunc_text -> Load End -> \(companyArray.count)")
        } else if likeButton.backgroundColor == truqButtonColor {
            deleteCoreData()
            isNotLike()
            print("likeFunc_text -> Delete End -> \(companyArray.count)")
        }
    }
    
    
}

extension String {
    func replaced(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespaces() -> String {
        return self.replaced(string: " ", replacement: "")
    }

}
