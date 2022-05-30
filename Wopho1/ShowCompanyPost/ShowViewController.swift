//
//  ShowViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 15.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
import FirebaseDatabase
import SDWebImage

protocol moveHeader {
    func headerIsMoving()
}

class ShowViewController: UIViewController, MFMailComposeViewControllerDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate {
    
    
    // MARK: - Layout
    @IBOutlet weak var collectionViewCell: UICollectionView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var toolBarBlur: UIView!
    
    @IBOutlet weak var headerULContraintRight: NSLayoutConstraint!
    @IBOutlet weak var headerULContraintLeft: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewTopConstraints: NSLayoutConstraint!
    
//    @IBOutlet weak var headerUnderlineConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var markCompanyLabel: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var streetImage: UIImageView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companyImageBlur: UIImageView!
    @IBOutlet weak var headerUnderline: UIView!
    @IBOutlet weak var companyUnderline: UIView!
    
    //MARK: - Layout which iPhone
    @IBOutlet weak var topConstraintBackButton: NSLayoutConstraint!
    
    
    var lastContent: CGFloat = 0.00
    
    
    var moveHeaderDelegate: moveHeader?
    
//    @IBOutlet weak var abortButton: UIButton!
    
    func delegateMoveHeader() {
        moveHeaderDelegate?.headerIsMoving()
        print("funktioniert das ---- Controller")
    }
    // MARK: - var / let
//    var search = [PostModel]()
//    var searchId = ""
//
//    var posts = [PostModel]()
//    var _postText = ""
//
//    var postId = [PostModel]()
//    var _postId = ""
    
    // zuständig für segue aus PostSwipe
    var userUid = [PostModel]()
    var companyId = [UserModel]()
    var _userUid = ""
    
    // test für second unwind methode
    var postIdFromLibrary = [PostModel]()
    
    // test für unwind zu SearchVC
    var userUidForUnwindSegue = ""
    
    // zuständig f. PostText bei mail
    var postId: PostModel?
    var _postText = ""
    
    // zuständig f. Header Collection View
    var user: UserModel?
    var _headerUserUid = ""
    
    var headerHeightHandler = 0.0
    
    var headerVari: CGFloat = 0.00
    var headerHighRef: CGFloat = 0.00
    
    var mobile = ""
    var phone = ""
    var longitude = 0.0
    var lantitude = 0.0
    
    var tappedUserId = ""
    var tappedPostText = ""
    var tappedIndex: Int = 0
    
    // test für Cell high
    var cellHeight: CGFloat = 0.0
    
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: UINavigationController(), action: nil)
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.hasNotch {
            collectionViewCell.contentInset.bottom = view.safeAreaInsets.bottom + 25
            collectionViewCell.verticalScrollIndicatorInsets.bottom = view.safeAreaInsets.bottom + 25
        } else {
            collectionViewCell.contentInset.bottom = view.safeAreaInsets.bottom + 80
            collectionViewCell.verticalScrollIndicatorInsets.bottom = view.safeAreaInsets.bottom + 80
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        print("awake funtzt oder was")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CollectionView Content ----1 \(collectionViewCell.contentOffset.y)")
        print("high or \(topConstraintBackButton.constant)")
        if UIDevice.current.hasNotch {
        } else {
            topConstraintBackButton.constant = -5
        }
//        print("die Höhe der Tabbar \(self.tabBarController?.tabBar.frame.height)")
//        guard let tabBarHeight = tabBarController?.tabBar.frame.size.height else { return }
//        let newViewHeight = view.frame.size.height
//        view.frame.size.height = newViewHeight - tabBarHeight
        setupButton()
        headerSetup()
        print("PostId f. PostText---", _userUid)
        
        print("PostId f. PostText---", _postText)
        
//        collectionViewCell.backgroundColor = UIColor.init(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        collectionViewCell.dataSource = self
        collectionViewCell.delegate = self
        collectionViewCell.allowsSelection = true
        
        print("scroll view test -- indicator \(collectionViewCell.scrollIndicatorInsets)")
//        fetchSearch()
//        fetchPostText()
//        fetchPostId()
        
        loadCompanyPosts()
        fetchCompanyID()
        
//        loadTouchedPost()
        self.navigationItem.titleView = navigationTitleShowVC(text: "App_Name")
        
        print("INDEX wer <-> lädt")
        
        
        let backButtonImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: self, action: #selector(unwindFunc))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.barStyle = .default
        
        if let layout = collectionViewCell.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
//        self.traitCollection.userInterfaceStyle = UIUserInterfaceStyle.light
//        let backButtonImage = UIImage(systemName: "chevron.left")
//        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: nil, action: nil)
//        let backButtonTitle = UIBarButtonItem(title: "Zurück", style: UIBarButtonItem.Style.done, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backButton
//        let backButtonImage = UIImage(systemName: "chevron.left")
//        self.navigationItem.leftBarButtonItem?.image = backButtonImage
        
//        self.navigationController?.navigationBar.backItem?.title = "gelb"
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
//        let backButton = UIBarButtonItem(title: "jkhkj", style: UIBarButtonItem.Style.done, target: nil, action: nil)
//        
//        
//        navigationItem.leftBarButtonItem = backButton
//        let backButtonImage = UIImage(systemName: "chevron.left")
//        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: nil, action: nil)
//        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowDetail" {
            let showDetailVC = segue.destination as! ShowDetailVC
            showDetailVC.segueUserId = self.tappedUserId
            showDetailVC.seguePostText = self.tappedPostText
            showDetailVC.segueIndex = self.tappedIndex
        }
    }
    
    func headerDynamicPlus() {
        print("header height Plus \(collectionViewTopConstraints.constant)")
        switch true {
        case collectionViewTopConstraints.constant >= 150 - headerHighRef:
//            headerUnderline.alpha = 1.0
            infoImage.alpha = 1.0
            infoLabel.alpha = 1.0
            streetImage.alpha = 1.0
            streetLabel.alpha = 1.0
            companyImage.alpha = 1.0
            companyImageBlur.alpha = 1.0
            cityImage.alpha = 1.0
            zipLabel.alpha = 1.0
            cityLabel.alpha = 1.0
        case collectionViewTopConstraints.constant >= 145 - headerHighRef:
            infoImage.alpha = 1.0
            infoLabel.alpha = 1.0
            streetImage.alpha = 1.0
            streetLabel.alpha = 1.0
            companyImage.alpha = 1.0
            companyImageBlur.alpha = 1.0
            cityImage.alpha = 1.0
            zipLabel.alpha = 1.0
            cityLabel.alpha = 1.0
        case collectionViewTopConstraints.constant >= 123 - headerHighRef:
            streetImage.alpha = 1.0
            streetLabel.alpha = 1.0
            companyImage.alpha = 1.0
            companyImageBlur.alpha = 1.0
            cityImage.alpha = 1.0
            zipLabel.alpha = 1.0
            cityLabel.alpha = 1.0
        case collectionViewTopConstraints.constant >= 83 - headerHighRef:
//            companyUnderline.alpha = 0.0
            streetImage.alpha = 1.0
            streetLabel.alpha = 1.0
        default:
            break
        }
    }
    
    func headerAllPlus() {
//        headerUnderline.alpha = 1.0
        infoImage.alpha = 1.0
        infoLabel.alpha = 1.0
        streetImage.alpha = 1.0
        streetLabel.alpha = 1.0
        companyImage.alpha = 1.0
        companyImageBlur.alpha = 1.0
        cityImage.alpha = 1.0
        zipLabel.alpha = 1.0
        cityLabel.alpha = 1.0
    }
    
    func headerAllMinus() {
        streetImage.alpha = 0.0
        streetLabel.alpha = 0.0
        companyImage.alpha = 0.0
        companyImageBlur.alpha = 0.0
        cityImage.alpha = 0.0
        zipLabel.alpha = 0.0
        cityLabel.alpha = 0.0
        infoImage.alpha = 0.0
        infoLabel.alpha = 0.0
//        headerUnderline.alpha = 0.0
    }
    
    
    
    func headerDynamicMinus() {
        print("header height MINUS \(collectionViewTopConstraints.constant)")
        switch true {
        case collectionViewTopConstraints.constant < 83 + headerHighRef:
            print("minus_ B 83 hidden")
//            companyUnderline.alpha = 1.0
            streetImage.alpha = 0.0
            streetLabel.alpha = 0.0
            companyImage.alpha = 0.0
            companyImageBlur.alpha = 0.0
            cityImage.alpha = 0.0
            zipLabel.alpha = 0.0
            cityLabel.alpha = 0.0
            infoImage.alpha = 0.0
            infoLabel.alpha = 0.0
//            headerUnderline.alpha = 0.0
        case collectionViewTopConstraints.constant < 123 + headerHighRef:
            print("minus_ B 123 hidden \(collectionViewTopConstraints.constant)")
            print("minus_ B 123 _ RESULT \(123 - headerHighRef) && headerRef \(headerHighRef)")
            companyImage.alpha = 0.0
            companyImageBlur.alpha = 0.0
            cityImage.alpha = 0.0
            zipLabel.alpha = 0.0
            cityLabel.alpha = 0.0
            infoImage.alpha = 0.0
            infoLabel.alpha = 0.0
//            headerUnderline.alpha = 0.0
        case collectionViewTopConstraints.constant < 145 + headerHighRef:
            infoImage.alpha = 0.0
            infoLabel.alpha = 0.0
//            headerUnderline.alpha = 0.0
        case collectionViewTopConstraints.constant < 155 + headerHighRef:
            print("minus_ B 125 hidden")
//            headerUnderline.alpha = 0.0
        default:
            print("B 124 hidden")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let _indexPath = userUid[indexPath.row]
        view.endEditing(true)
        let _indexPath = indexPath.item
        print("INDEX wer <-> \(_indexPath)")
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ShowCollectionViewCell else { return }
        
        print("INDEX wer <-> \(cell.debugDescription)")
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll view __ \(scrollView.contentOffset.y) && CONSTRAINTS \(self.collectionViewTopConstraints.constant)")
        print("collection View high - 2222 - \(collectionViewTopConstraints.constant)")
        print("scroller ---1 \(scrollView.contentSize)")
        if scrollView.contentOffset.y < 0 && self.collectionViewTopConstraints.constant <= headerVari {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {

                self.collectionViewTopConstraints.constant -= scrollView.contentOffset.y * 10.33
                
                //self.collectionViewTopConstraints.constant -= scrollView.contentOffset.y * 5.33
                
                //self.headerUnderlineConstraint.constant -= scrollView.contentOffset.y
                self.headerDynamicPlus()
                print("scroll view_ 1 \(scrollView.contentOffset.y) &&&&& \(self.collectionViewTopConstraints.constant)")
            } completion: { _ in
            }
        } else if scrollView.contentOffset.y >= 0 && self.collectionViewTopConstraints.constant >= 50 {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
                self.collectionViewTopConstraints.constant -= scrollView.contentOffset.y / 15.33
                
                //self.collectionViewTopConstraints.constant -= scrollView.contentOffset.y / 225.33
                
                self.headerDynamicMinus()
                print("scroll view_ 2 \(scrollView.contentOffset.y) &&&&& \(self.collectionViewTopConstraints.constant)")
            } completion: { _ in
            }
//        } else if scrollView.contentOffset.y >= 0 && self.collectionViewCell.frame.size.height <= cellHeight + 500 {
//            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
//                self.collectionViewCell.translatesAutoresizingMaskIntoConstraints = false
//                self.collectionViewCell.frame.size.height += scrollView.contentOffset.y / 15.33
//                print("funtzt oda \(self.collectionViewCell.frame.size.height)")
//            } completion: { (end) in
//            }

        }

        print("CV_Constraint __ \(collectionViewTopConstraints.constant)")

        if collectionViewTopConstraints.constant < 50 {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
                self.collectionViewTopConstraints.constant = 50
                self.headerULContraintLeft.constant = 0
                self.headerULContraintRight.constant = 0
            } completion: { (end) in
//                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            
            

            print("scroll view_ 3 \(scrollView.contentOffset.y) &&&&& \(self.collectionViewTopConstraints.constant)")

        } else if collectionViewTopConstraints.constant >= headerVari {

            UIView.animate(withDuration: 0.2) {
                print("collection Constant - test \(self.infoLabel.text)")
                if self.infoLabel.isHidden == true {
                    self.collectionViewTopConstraints.constant = self.headerVari
                    self.headerULContraintLeft.constant = 10
                    self.headerULContraintRight.constant = 10
                    print("collection Constant - 115")
                    print("scroll view_ 4")
                } else {
                    self.collectionViewTopConstraints.constant = self.headerVari
                    self.headerULContraintLeft.constant = 10
                    self.headerULContraintRight.constant = 10
                    print("collection Constant - 147")
                    print("scroll view_ 5")
                }
            }
        }
        
        print("collection View high - 2.55555 - \(collectionViewTopConstraints.constant)")
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        if scrollView.contentOffset.y < 0 && self.collectionViewCell
//        if scrollView.contentOffset.y >= 0 && self.collectionViewCell.frame.size.height <= cellHeight + 500 {
//            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
//                self.collectionViewCell.frame.size.height += scrollView.contentOffset.y / 15.33
//            } completion: { (finish) in
//            }
//
//        }
//    }
    
    @objc func unwindFunc() {
        performSegue(withIdentifier: "unwindDefault", sender: self)
//        if postIdFromLibrary.count != 0 {
//            performSegue(withIdentifier: "unwindDefault", sender: self)
//        } else {
//            performSegue(withIdentifier: "", sender: self)
//        }
        print("visible Cards _the unwind yeeeeees")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    func headerSetup() {
        companyImage.layer.cornerRadius = companyImage.bounds.width/2
        companyImage.clipsToBounds = true
        companyImageBlur.layer.cornerRadius = 10
        companyImageBlur.clipsToBounds = true
        companyLabel.tintColor = .white
        streetLabel.tintColor = .white
        zipLabel.tintColor = .white
        cityLabel.tintColor = .white
        infoLabel.tintColor = .white
        companyUnderline.backgroundColor = .white
        headerUnderline.backgroundColor = .white
        
        streetLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        zipLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        cityLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        infoLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        
    }
    
    func setupButton() {
        
        disconfirmPhoneButton()
        disconfirmLocationButton()
//        confirmPhoneButton()
//        confirmLocationButton()
        
        let blurEffectToolBar = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        let blurEffectToolBarView = UIVisualEffectView(effect: blurEffectToolBar)
        blurEffectToolBarView.frame = toolBarBlur.bounds
        blurEffectToolBarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toolBarBlur.addSubview(blurEffectToolBarView)
        toolBarBlur.layer.cornerRadius = 10
        toolBarBlur.clipsToBounds = true
        toolBarBlur.backgroundColor = .clear
        toolBar.backgroundColor = .clear
        toolBar.layer.cornerRadius = 10
        toolBar.clipsToBounds = true
        
//        let blueEffectImage = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
//        let blurEffectImageView = UIVisualEffectView(effect: blueEffectImage)
//        blurEffectImageView.frame = companyImageBlur.bounds
//        blurEffectImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        companyImageBlur.addSubview(blurEffectImageView)
//        companyImageBlur.layer.cornerRadius = 10
//        companyImageBlur.clipsToBounds = true
//        companyImageBlur.backgroundColor = .clear
        
        //companyImage.isHidden = true
    }
    
    func confirmPhoneButton() {
        let phoneImage = UIImage(systemName: "phone")
        phoneButton.setImage(phoneImage, for: .normal)
        phoneButton.layer.cornerRadius = phoneButton.bounds.width/2
        phoneButton.imageView?.tintColor = truqButtonColor
        phoneButton.backgroundColor = .white
        phoneButton.layer.borderWidth = 2
        phoneButton.tintColor = truqButtonColor
        phoneButton.layer.borderColor = phoneButton.tintColor.cgColor
        phoneButton.isEnabled = true
    }
    
    func disconfirmPhoneButton() {
        phoneButton.imageView?.tintColor = darkgrayButtonColor
        phoneButton.layer.cornerRadius = phoneButton.bounds.width/2
        phoneButton.layer.borderWidth = 0
        phoneButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        phoneButton.isEnabled = false
    }
    
    func confirmLocationButton() {
        let locationImage = UIImage(systemName: "location.fill")
        locationButton.setImage(locationImage, for: .normal)
        locationButton.layer.cornerRadius = locationButton.bounds.width/2
        locationButton.imageView?.tintColor = truqButtonColor
        locationButton.backgroundColor = .white
        locationButton.layer.borderWidth = 2
        locationButton.tintColor = truqButtonColor
        locationButton.layer.borderColor = locationButton.tintColor.cgColor
        locationButton.isEnabled = true
    }
    
    func disconfirmLocationButton() {
        locationButton.imageView?.tintColor = darkgrayButtonColor
        locationButton.layer.cornerRadius = locationButton.bounds.width/2
        locationButton.layer.borderWidth = 0
        locationButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        locationButton.isEnabled = false
    }
    
    // MARK: - Load Posts
//    func fetchSearch() {
//        PostApi.shared.queryPost(withText: searchId) { (post) in
//            self.search.append(post)
//            self.collectionViewCell.reloadData()
//        }
//    }
//
//    func fetchPostText() {
//        PostApi.shared.queryPost(withText: _postText) { (post) in
//            self.posts.append(post)
//            self.collectionViewCell.reloadData()
//            print("_postText -> ShowViewCollectionCell", post.postText)
//        }
//    }
    
//    func fetchPostId() {
//        PostApi.shared.observePost(withPodId: _postId) { (post) in
//            self.postId.insert(post, at: 0)
//            self.collectionViewCell.reloadData()
//        }
//    }
    
    func loadCompanyPosts() {
        PostApi.shared.observeMyPost(withUid: _userUid) { (Id) in
            print("sag mir die id ---k \(Id)")
            PostApi.shared.observePost(withPodId: Id) { (postId) in
                self.userUid.insert(postId, at: 0)
                self.collectionViewCell.reloadData()
            }
        }
    }
    
    // TEST wird erstmal nicht benötigt, entnehmen sofort den Text
//    func loadTouchedPost() {
//        PostApi.shared.observePost(withPodId: _postId) { (postText) in
//            self.postId = postText
//            print("loadTouch--->",self.postId.debugDescription)
//        }
//    }
    
    func fetchCompanyID() {
        print("fetchUserUid !!!!!--\(_userUid)")
        UserApi.shared.observeUser(uid: _userUid) { (companyId) in
            self.user = companyId
            self.collectionViewCell.reloadData()
            
            if let _companyName = companyId.username {
                self.companyLabel.text = _companyName
            }
            
            if let _phone = companyId.phone {
                self.phone = _phone
//                self.confirmPhoneButton()
            }
            
            if let _mobile = companyId.mobilePhone {
                self.mobile = _mobile
//                self.confirmPhoneButton()
            }
            
            if self.mobile == "" && self.phone == "" {
                self.disconfirmPhoneButton()
            } else {
                self.confirmPhoneButton()
            }
            
            if let _longitude = companyId.longitude, let _latitude = companyId.latitude {
                if _longitude == 0.0 || _latitude == 0.0 {
                    self.disconfirmLocationButton()
                } else {
                    self.confirmLocationButton()
                    self.longitude = _longitude
                    self.lantitude = _latitude
                }
                
            }
            
            if companyId.street != "" {
                self.streetLabel.text = companyId.street
            } else {
                self.streetImage.isHidden = true
                self.streetLabel.isHidden = true
            }
            
            if companyId.countryCode != "" {
                self.zipLabel.text = companyId.countryCode
            } else {
                self.zipLabel.isHidden = true
            }
            
            if companyId.city != "" {
                self.cityLabel.text = companyId.city
            } else {
                self.cityLabel.isHidden = true
            }
            
            if self.cityLabel.text == "" && self.zipLabel.text == "" {
                self.cityLabel.isHidden = true
                self.cityImage.isHidden = true
                self.zipLabel.isHidden = true
            }
            
            if companyId.textForEverything != "" {
                self.headerVari = 147
                self.headerHighRef = 0.00
                self.infoLabel.text = companyId.textForEverything
                self.collectionViewTopConstraints.constant = self.headerVari
            } else {
                self.infoImage.isHidden = true
                self.infoLabel.isHidden = true
                self.headerVari = 115
                self.headerHighRef = -28
                UIView.animate(withDuration: 0.2) {
                    self.collectionViewTopConstraints.constant = self.headerVari
                }
            }
            
            guard let url = URL(string: companyId.companyImageUrl!) else { return }
            self.companyImage.sd_setImage(with: url) { _, _, _, _ in
            }
//            self.companyImageBlur.sd_setImage(with: url) { _, _, _, _ in
//            }
        }
    }
    
    // MARK: - Location Setup
    
    func locationSuccess() {
        guard let urlAppleMaps = URL(string: "http://maps.apple.com/?daddr=\(lantitude),\(longitude)") else { return }
//        guard let urlGoogleMaps = URL(string: "comgooglemaps://?saddr=\(lantitude),\(longitude)&directionsmode=driving") else { return }
        guard let urlGoogleMaps = URL(string: "comgooglemaps://?q=\(lantitude),\(longitude)&zoom=14&views=traffic") else { return }
        
        guard let webGoogleMaps = URL(string: "https://www.google.co.in/maps/dir/?q=\(lantitude),\(longitude)&zoom=14&views=traffic") else { return }
        
        guard let openGoogleMaps = URL(string: "comgooglemaps://") else { return }
        
        let alert = UIAlertController(title: "Karte wählen", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        
        if UIApplication.shared.canOpenURL(urlAppleMaps) {
            let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) { (action) in
                UIApplication.shared.open(urlAppleMaps)
            }
            alert.addAction(appleMaps)
        }
        
        
        if UIApplication.shared.canOpenURL(openGoogleMaps) {
            let googleMaps = UIAlertAction(title: "Google Maps", style: .default) { (action) in
                UIApplication.shared.open(urlGoogleMaps)
            }
            alert.addAction(googleMaps)
        } else {
            let webGoogleMaps = UIAlertAction(title: "Web Google Maps", style: .default) { (action) in
                UIApplication.shared.open(webGoogleMaps)
            }
            alert.addAction(webGoogleMaps)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorLocation() {
        let error = UIAlertController(title: "Hinweis!", message: "Adresse nicht hinterlegt", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "zurück", style: .cancel, handler: nil))
        present(error, animated: true, completion: nil)
    }
    
    // MARK: - Phone Setup
    
    func isPhoneAndMobile() {
        let _phone = phone.removeWhitespace()
        let _mobile = mobile.removeWhitespace()
        
        guard let urlLandline: NSURL = NSURL(string: "tel://\(_phone)") else { return }
        
        guard let urlMobile: NSURL = NSURL(string: "tel://\(_mobile)") else { return }
        
        let alert = UIAlertController(title: "Welche Rufnummer?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        
        let firsNumber = UIAlertAction(title: "Festnetz", style: .default) { (action) in
            UIApplication.shared.open(urlLandline as URL, options: [:], completionHandler: nil)
        }
        
        let secondNumber = UIAlertAction(title: "Mobilfunk", style: .default) { (action) in
            UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
        }
        
        alert.addAction(firsNumber)
        alert.addAction(secondNumber)
        self.present(alert, animated: true, completion: nil)
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
    
    func phoneError() {
        let error = UIAlertController(title: "Hinweis!", message: "Keine Telefonnummer hinterlegt", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "zurück", style: .cancel, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    // MARK: - mail setup
    func mailSetup() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["s.schmitt@sld-logistik.de"])
            mail.setSubject("test Mail")
            mail.setMessageBody("Nachricht sollte da stehen", isHTML: false)
            self.present(mail, animated: true, completion: nil)
        } else {
            self.showMailError()
        }
    }
    
    func showMailError() {
        let error = UIAlertController(title: "Email konnte nicht gesendet werden", message: "Bitte prüfen sie ihre Email-Einstellung", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.showMailError()
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - error empty phone
    func errorEmptyPhoneNumber() {
        let error = UIAlertController(title: "Achtung!", message: "Es wurde kein Nummer hinterlegt", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Zurück", style: .cancel, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    // MARK: - Navigation Bar Setup
    func navigationTitleShowVC(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        
        let tapGestureNaviTitle = UITapGestureRecognizer(target: self, action: #selector(titleUnwindShowVC))
        label.addGestureRecognizer(tapGestureNaviTitle)
        label.isUserInteractionEnabled = true
        
        return label
    }
    
    @objc func titleUnwindShowVC() {
        performSegue(withIdentifier: "titleUnwindShowVC", sender: self)
    }
    
    func testString() {
        print("!!!!___ >> unwind Nachricht k00mt an")
    }
    
    // MARK: - Action
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindDefault", sender: self)
    }
    
    
    
    @IBAction func unwindtoShowVC(_ senderTesterOne: UIStoryboardSegue) {
        let showVC = ShowViewController()
//        navigationController?.popToViewController(showVC, animated: true)
//        showVC.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        navigationController?.popToRootViewController(animated: true)
        print("visible Cards _-X___funtzt 2.o")
        
        showVC.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popover = showVC.popoverPresentationController {
            popover.delegate = self
            collectionViewCell.reloadData()
            
            testString()
            print("visible Cards _-X___funtzt")
        }
        
//        if senderTesterOne.source is SearchPostViewController {
//            if let senderVC = senderTesterOne.source as? SearchPostViewController {
////                senderVC.dismiss(animated: true, completion: nil)
////                senderVC.modalPresentationStyle = UIModalPresentationStyle.popover
////                if let popover = senderVC.popoverPresentationController {
////                    popover.delegate = self
////
////                }
//
////                collectionViewCell.reloadData()
////
////                testString()
//            }
//        }
    }
    
    @IBAction func unwindFromShowDetailVC(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindDefault", sender: self)
    }
    
    @IBAction func phoneButtonTapped(_ sender: UIButton) {
        if phone.count != 0 && mobile.count != 0 {
            isPhoneAndMobile()
        } else if phone.count != 0 {
            isPhone()
        } else if mobile.count != 0 {
            isMobile()
        } else {
            phoneError()
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        if longitude != 0 && lantitude != 0 {
            locationSuccess()
        } else {
            errorLocation()
        }
    }
    
    
//    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
//        let id = identifier
//        print("funtzt der Unwind 2.o")
//        if id == "unwindFromShowImage" {
//            let unwindSeg = UnwindSegue(identifier: id, source: fromViewController, destination: toViewController) {
//                print("funtzt der Unwind")
//
//            }
//            return unwindSeg
//        }
//        return segueForUnwinding(to: fromViewController, from: toViewController, identifier: id)
//    }
    
    
    
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//
//
//        if unwindSegue.identifier == "unwindFromShowImage" {
//            print("unwindSegue >>>> funtzt \(unwindSegue.identifier)")
//            print("subsequentVC >>>> funtzt \(subsequentVC.debugDescription)")
//
//            let dst = unwindSegue.destination as! SearchPostViewController
//            let src = unwindSegue.source as! ShowViewController
//
////            let dst = subsequentVC as? SearchPostViewController
//
//            src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
//            dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width , y: 0)
//
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
//                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//
//            } completion: { (finished) in
//                src.navigationController?.present(dst, animated: false, completion: nil)
//                print(">>>> funtzt whats going on")
//            }
//
//        }
//    }


    
}
// MARK: - CollectionView Datasource
extension ShowViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if _postText.count == 0 {
//            print("search<<<<<<",search.count)
//            return search.count
//        }
//        print("_postText>>>>>>",posts.count)
        
        
        return userUid.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCollectionViewCell", for: indexPath) as? ShowCollectionViewCell {
////            if _postText.count == 0 {
////                cell.search = search[indexPath.row]
////            } else {
////                cell.search = posts[indexPath.row]
////            }
//
//            return cell
//        }
//        return UICollectionViewCell()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCollectionViewCell", for: indexPath) as! ShowCollectionViewCell
        //cell.contentView.isUserInteractionEnabled = true
        //collectionViewTopConstraints.constant = 130
        cell.search = userUid[indexPath.row]
        cell.delegate = self
        cell.delegatePostImage = self
        cell.indexRow = indexPath.row
        print("collection View high - 3 - \(collectionViewTopConstraints.constant)")
        print("cell _ Frame \(cell.frame)")
        print("funtzt oda -> höhe <- \(collectionViewCell.frame.size.height)")
        cellHeight = collectionViewCell.frame.size.height
        print(" 3 \(collectionViewCell.contentOffset.y)")
//        cell.clipsToBounds = true
        print("INDEX wer <-> CellSelbst -> \(indexPath.row)  && ID? \(cell.search?.postId)")
        return cell
    }
    
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ShowHeaderCollectionViewCell", for: indexPath) as! ShowHeaderCollectionViewCell
//        
//        cell.contentView.isUserInteractionEnabled = false
//        
//        
//        
//        print("scroll view test -- höhe #### \(cell.frame.height)")
//        
//        if let user = self.user {
//            cell.user = user
//            cell.delegate = self
//            cell.unwindDelegate = self
//            
////            cell.post = postId
//            cell.postText = _postText
//        }
//        
////        if self.postId != nil {
////            cell.post = postId
////        }
//        
//        return cell
//    }
}

// MARK: - CollectionView FlowLayout
extension ShowViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2.19 - 1
        let height: CGFloat = collectionView.frame.height / 3.05 - 1
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
}


extension String {
    
//    func replaces(string: String, replacement: String) -> String {
//        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
//    }
//
//    func removeWhitespace() -> String {
//        return self.replaces(string: " ", replacement: "")
//    }
    
    
}

extension ShowViewController: SearchCellDelegate {
    func tappedSearch(useruid: String, postId: String, indexPath: Int) {
        tappedPostText = postId
        tappedUserId = useruid
        tappedIndex = indexPath
        performSegue(withIdentifier: "segueShowDetail", sender: self)
        
        
        
//        func unwindTest(toViewController: UIViewController, fromViewController: UIViewController, identifier: String ) -> UIStoryboardSegue {
//
//            let id = identifier
//
//            if id == "unwindFromShowImage" {
//                let unwindSeg = UnwindSegue(identifier: id, source: fromViewController, destination: toViewController) {
//
//                }
//                return unwindSeg
//            }
//            return unwindTest(toViewController: toViewController, fromViewController: fromViewController, identifier: identifier)
//        }
    }
    
    
}

extension ShowViewController: unwindFromShowHeader {
    func headerUnwind() {
        performSegue(withIdentifier: "unwindDefault", sender: self)
        print("Unwind kommt an")
    }
}




