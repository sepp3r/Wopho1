//
//  CompanyHomeViewController.swift
//  PiCCO
//
//  Created by Sebastian Schmitt on 19.07.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage
import Keychains
import CoreLocation
import Photos
import PhotosUI
import Network


class CompanyHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITabBarControllerDelegate {
    
    
    // MARK: - Outlet
    @IBOutlet weak var checkLoginLabel: UILabel!
    @IBOutlet weak var imageCheckmark: UIImageView!
    
    // Neues Layout für Umbau 2.0
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var toolBarViewBlur: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var camerButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notifyLabel: UILabel!
    
    
//    @IBOutlet weak var cardImageView: UIView!
    
    // Punkt Füllung vorhanden 2.0 ----------
//    @IBOutlet weak var cardTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var cardTopConstraint: NSLayoutConstraint!
    
    
    
//    @IBOutlet weak var backgroundImage: UIImageView!
//    @IBOutlet weak var mainImageView: UIImageView!
//    @IBOutlet weak var photoChooseView: UIStackView!
    
//    @IBOutlet weak var categoryTextField: UITextField!
//    @IBOutlet weak var shareButton: UIButton!
//    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorSetting: UIActivityIndicatorView!
    
    // Punkt Füllung vorhanden
    @IBOutlet weak var photoLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewPhotoLabelConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var cameraButton: UIButton!
//    @IBOutlet weak var photoCollectionButton: UIButton!
//    @IBOutlet weak var libraryButton: UIButton!
    
    // Punkt Füllung vorhanden
    @IBOutlet weak var statusTextLabelConstraint: NSLayoutConstraint!

    
//    @IBOutlet weak var toolBar: UIView!
//    @IBOutlet weak var toolBarBlurEffect: UIView!
//    // Punkt Füllung vorhanden
//    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var milkLoginView: UIView!
    @IBOutlet weak var secondLoginView: UIView!
    
    
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var mainSettingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var trailingConstant: NSLayoutConstraint!
//    @IBOutlet weak var trailingConstant: NSLayoutConstraint!
    
    
    @IBOutlet weak var logoutOutlet: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
//    @IBOutlet weak var leaingConstraint: NSLayoutConstraint!
//    @IBOutlet var leaingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var leaingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var leaingConstraint: NSLayoutConstraint!
    
    // Punkt Füllung vorhanden 2.0
//    @IBOutlet weak var leaingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var leaingConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companyImageBlur: UIImageView!
    
    @IBOutlet weak var companyNameTextfield: UITextField!
    @IBOutlet weak var underlineForCompanyName: UIView!
    
    @IBOutlet weak var countryCodesTextField: UITextField!
    @IBOutlet weak var buttonRadius25: UIButton!
    @IBOutlet weak var buttonRadius50: UIButton!
    @IBOutlet weak var buttonRadius100: UIButton!
    @IBOutlet weak var buttonRadius200: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var locationPinImage: UIImageView!
    @IBOutlet weak var textForEverything: UITextField!
    
    
    @IBOutlet weak var saveSettingButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var logoutActivityIndiactor: UIActivityIndicatorView!
    
    @IBOutlet weak var notInternetView: UIView!
    @IBOutlet weak var notInternetLabel: UILabel!
    @IBOutlet weak var notInternetImage: UIImageView!
    
    //MARK: layout
    
    
    // MARK: - var / let
    let buttonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    let redButtonColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
//    let redButtonColor = UIColor(red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    
    let darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    
    var notInternetViewY: CGFloat = 0
    var notInternetDefaultY: CGFloat = 1000
    
    var shareButtonCenter : CGPoint!
    var abortButtonCenter : CGPoint!
    var delegate: CameraViewController!
    var selectedImage: UIImage?
    var selectedCompanyImage: UIImage?
    
    var loginViewX: CGFloat = 0
    var loginViewY: CGFloat = 0
    var deafultLoginViewX: CGFloat = 120
    var defaultLoginViewY: CGFloat = 1000
    var toolBarX: CGFloat = 0
    var toolBarY: CGFloat = 0
    var defaultToolBarX: CGFloat = 27.0
    var defaultToolBarY: CGFloat = 1116.0
    
    // SEGUE TEST
    let editSegue = "editSegue"
    var testImage: UIImage?
    var userMail = ""
    var tappedIndex: Int = 0
    // ENDE
    
    // Data for CollectionView
    var userUid = [PostModel]()
    var companyId = [UserModel]()
    var _userUid = ""
    
    lazy var gecoder = CLGeocoder()
    var latitude = 0.0
    var longitude = 0.0
    
    var newImageForCard: UIImage?
    var holdTheOldComImage: UIImage?
    
    // var for Radius
//    let radius25 = 25.0
//    let radius50 = 50.0
//    let radius100 = 100.0
//    let radius200 = 200.0
    
    var radiusChoosed = 0.0
    
    var initialCenter = CGPoint()
    
    // storageID
    var storagePostTheId = ""
    
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupUserInformation(user: _user)
        }
    }
    
    func setupUserInformation(user: UserModel) {
        if user.uid != nil {
            print("zähl mal \(user.uid)")
            _userUid = user.uid!
        }
        companyNameTextfield.text = user.username
        emailTextField.text = user.email
        userMail = user.email!
        countryCodesTextField.text = user.countryCode
        streetTextField.text = user.street
        cityTextField.text = user.city
        countryTextField.text = "Deutschland"
        print("kommt da nichts textForEverything \(user.textForEverything)")
        textForEverything.text = user.textForEverything
//        radiusChoosed = user.radius!
        phoneTextField.text = user.phone
        mobilePhoneTextField.text = user.mobilePhone
        if user.radius != nil {
            radiusChoosed = user.radius!
        }
        
        
        if user.latitude != nil || user.longitude != nil {
            if user.latitude != 0.0 || user.longitude != 0.0 {
                latitude = user.latitude!
                longitude = user.longitude!
                print("Setting test __ LAT&LONG _END_ \(latitude), \(longitude)")
            }
        }
        
        
        
//        homepageTextField.text = user.homepage
        countryCodeFieldCheck()
        loadCompPost()
        guard let url = URL(string: user.companyImageUrl!) else { return }
        print("Wann kommt return 11111")
        companyImage.sd_setImage(with: url) { (_, _, _, _) in
        }
        
//        companyImageBlur.sd_setImage(with: url) { (_, _, _, _) in
//        }
        
        
        
        
        print("Wann kommt return 22222")
        
        
        buttonCheckIfWhite()
        
        // UMBAU 2.0
//        categoryTextField.delegate = self
        
        print("open Menu Check >>>>>> \(user.countryCode?.count) \(user.phone?.count)  \(user.mobilePhone?.count)")
        
        if user.countryCode?.count == nil && user.phone?.count == nil && user.mobilePhone?.count == nil {
            dataProfileCheck()
            print("funktioniert der open Menu check-------#####------")
        }
        
        constraintCard()
        motionOptionDefaultPosition()
        
        print("__________sag mir den Radius______\(radiusChoosed)")
        
//        guard let radiusDataOpen = user.radius else { return }
//
//        radiusChoosed = radiusDataOpen
//        print("leaningConstrain ZUSTAND ______ \(self.leaingConstraint.constant.description)")
    }
    
    //let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))
    
    // MARK: - View Lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UMBAU 2.0
//        categoryTextField.layer.borderColor = UIColor.white.cgColor
        tabBarController!.tabBar.items![3].isEnabled = false
        
        var haseNotch: Bool {
            if #available(iOS 11.0, tvOS 11.0, *) {
                let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                
                return bottom > 0
            } else {
                return false
            }
        }
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        print("scrollView test -> 1  \(scrollView.debugDescription)")
        print("mainSettingView test -> 2  \(mainSettingView.debugDescription)")
        print("viewSetting test -> 3  \(viewSetting.debugDescription)")
        print("collectionView test -> 3  \(collectionView.debugDescription)")
        
        
        let scrollWidth = mainSettingView.bounds.width
        let scrollHeight = mainSettingView.bounds.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        mainSettingView.isHidden = true
        
        
        checkInternet()
        notInternetViewY = notInternetView.frame.origin.y
        notInternetView.frame.origin.y = notInternetDefaultY
        
        
        
        // UMBAU 2.0
//        statusTextLabelConstraint.constant = -150
        
        fetchCurrentUser()
//        loadCompPost()
        
        companyNameTextfield.delegate = self
        emailTextField.delegate = self
        tabBarController?.delegate = self
        
        // UMBAU 2.0
//        categoryTextField.delegate = self
        
//        homepageTextField.delegate = self
        mobilePhoneTextField.delegate = self
        phoneTextField.delegate = self
        countryCodesTextField.delegate = self
        streetTextField.delegate = self
        textForEverything.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        
        activityIndicator.stopAnimating()
        activityIndicatorSetting.stopAnimating()
        
//        mainImageView.isUserInteractionEnabled = true
//        companyImage.isUserInteractionEnabled = true

//        addTapGestureImageView()
        setupView()
        countryCodeBottonSetup()
        addTargetToTextField()
        addTargetToCountryCode()
        addTargetToOtherSettingsTF()
        
        // UMBAU 2.0
//        categoryTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        countryCodeFieldCheck()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let panGestureImage = UIPanGestureRecognizer(target: self, action: #selector(panGesture(panGesture:)))
        // UMBAU 2.0
//        mainImageView.addGestureRecognizer(panGestureImage)
        
        panGestureImage.maximumNumberOfTouches = 2
        panGestureImage.minimumNumberOfTouches = 2
        
//        mainImageView.isUserInteractionEnabled = true
        
        // UMBAU 2.0
//        mainImageView.isMultipleTouchEnabled = true
        
//        mainImageView.isUserInteractionEnabled = false
//        companyImage.isUserInteractionEnabled = false
        
        delegate?.delegateImage = self
        
        self.navigationItem.titleView = navigationTitle(text: "App_Name")
        
        let backButtonImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: self, action: #selector(unwindToHomeVC))
        self.navigationItem.leftBarButtonItem = backButton
        
//        print("checkImage__ __ constant 2.o \(leaingConstraint.constant)")
//        dataProfileCheck()
        addTapGestureImageView()
        
        // UMBAU 2.0
//        if newImageForCard != nil {
//            mainImageView.image = newImageForCard
//            mainImageView.clipsToBounds = true
//        }
    }
    
    // MARK: - Overrides
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ich verlasse dich")
        super.viewDidDisappear(animated)
        if tabBarController?.tabBar.items![3].isEnabled == false {
            tabBarController!.tabBar.items![3].isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController!.tabBar.items![3].isEnabled = false
        imageDidChange()
        
//        milkLoginView.isHidden = true
        if userUid.count == 0 {
            galleryButtonNotEnable()
        } else if userUid.count > 0 {
            galleryButtonEnable()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // MARK: - Problem mit den Falsch laden der ToolBar
        
        // UMBAU 2.0
//        if toolBar.isHidden == true {
////            showToolBar()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.showToolBar()
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let previewViewController = segue.destination as! PreviewViewController
            previewViewController.previewImageExchanger = self.testImage
            holdTheOldComImage = companyImage.image
            previewViewController.incomeSegue = "editSegue"
            previewViewController.view.isHidden = true
        } else if segue.identifier == "showToEditVC" {
            let toEditViewController = segue.destination as! ToEditVC
            toEditViewController.companyPost = userUid
            print("wie oft gehst du ------- 1")
            toEditViewController._userMail = userMail
            toEditViewController.segueIndex = tappedIndex
            
            
        } else if segue.identifier == "ShowCameraVC" {
            
        } else if segue.identifier == "showPreviewByCompanyHome" {
            let showPreviewPic = segue.destination as! PreviewUserPicViewController
            showPreviewPic.view.isHidden = true
            showPreviewPic.incomeSegue = "unwindToCompHome"
            holdTheOldComImage = companyImage.image
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("tabbar test -> 2 -- \(tabBarController.selectedIndex)")
        
        if tabBarController.selectedIndex == 3 {
            tabBarItem.isEnabled = false
        }
    }
    
    
    
    
    // MARK: - UIView Animation
    
    func showToolBar() {
        // UMBAU 2.0
//        toolBar.isHidden = false
        
        milkLoginView.isHidden = false
        milkLoginView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.milkLoginView.alpha = 1.0
        } completion: { (_) in
            self.switchToToolBar()
        }
    }
    
    func switchToToolBar() {
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.25, delay: 0.5, options: .curveLinear) {
            self.milkLoginView.frame.origin.y = 2000
        } completion: { (_) in
            self.milkLoginView.isHidden = true
            UIView.animate(withDuration: 0.25) {
                
                // UMBAU 2.0
//                self.toolBar.translatesAutoresizingMaskIntoConstraints = false
//                self.toolBar.frame.origin.x = self.toolBarX
//                self.toolBar.frame.origin.y = self.toolBarY
//                self.photoChooseView.isHidden = false
                
                
//                print("checkImage__ __ constant 3.o \(self.leaingConstraint.constant)")
                self.addTapGestureImageView()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    
    func shareStarts() {
        self.activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 1.5) {
            
            // UMBAU 2.0
//            self.toolBar.translatesAutoresizingMaskIntoConstraints = true
//            self.toolBar.frame.origin.y = 1000
//            self.abortButton.isEnabled = false
//            self.shareButton.isEnabled = false
//            self.libraryButton.isEnabled = false
//            self.photoCollectionButton.isEnabled = false
//            self.cameraButton.isEnabled = false
            
            
            self.milkLoginView.isHidden = false
            self.checkLoginLabel.isHidden = true
            self.imageCheckmark.isHidden = true
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func shareSuccessful() {
        checkmarkSuccessImage()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.imageCheckmark.isHidden = false
            self.checkLoginLabel.isHidden = false
        } completion: { (_) in
            self.defaultToolbarLayout()
        }

    }
    
    func shareError() {
        checkmarkErrorImage()
        UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveLinear) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.imageCheckmark.isHidden = false
            self.checkLoginLabel.isHidden = false
        } completion: { (_) in
            self.defaultToolbarLayout()
        }

    }
    
    func defaultToolbarLayout() {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveLinear) {
            // UMBAU 2.0
//            self.toolBar.frame.origin.x = self.toolBarX
//            self.toolBar.frame.origin.y = self.toolBarY
            
        } completion: { (_) in
            // UMBAU 2.0
//            self.abortButton.isEnabled = true
//            self.shareButton.isEnabled = true
//            self.libraryButton.isEnabled = true
//            self.cameraButton.isEnabled = true
//            self.photoCollectionButton.isEnabled = true
            
            self.milkLoginView.isHidden = true
        }
    }
    
    func shareAtError() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.imageCheckmark.isHidden = false
            self.checkLoginLabel.font = self.checkLoginLabel.font.withSize(16)
            self.checkLoginLabel.text = "Upload Fehler"
            self.checkLoginLabel.isHidden = false
        } completion: { (_) in
            self.defaultToolbarLayout()
        }
    }
    
    
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("§§§§§---§§§--wirst du geladen")
//        milkLoginView.isHidden = true
//    }
    
    // MARK: - Tab Bar functions
    
    
    
    
    // MARK: - Core Location
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            // gehört text falls adresse nicht gefunden wurde
        } else {
//            var location: CLLocation?
//            if let placemarks = placemarks, placemarks.count > 0 {
//                location = placemarks.first?.location
//            }
//
//            if let location = location {
//                let coordinate = location.coordinate
//                // wo abspeichern
//                latitude = coordinate.latitude
//                longitude = coordinate.longitude
//
//                print("Textfeld -> \(coordinate.latitude), \(coordinate.longitude)")
//                print("Textfeld -> 2 -> \(latitude), \(longitude)")
//            }
        }
    }
    
    // MARK: - Fetch current user
    func fetchCurrentUser() {
        UserApi.shared.observeCurrentUser { (currentUser) in
            self.user = currentUser
        }
    }
    
    func loadCompPost() {
        print("zähl mal \(_userUid)")
        PostApi.shared.observeMyPost(withUid: _userUid) { iD in
            PostApi.shared.observePost(withPodId: iD) { postId in
                self.userUid.insert(postId, at: 0)
                self.collectionView.reloadData()
                if self.userUid.count == 0 {
                    self.galleryButtonNotEnable()
                } else if self.userUid.count > 0 {
                    self.galleryButtonEnable()
                }
            }
        }
    }
    
    // MARK: - KeyboardSettings
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        UIView.animate(withDuration: 0.1) {
            let bottomInset = keyboardFrame?.height
            self.scrollView.contentInset.bottom = bottomInset! + 5
            self.scrollView.scrollIndicatorInsets.bottom = bottomInset! + 5
            print("_KOMMT_")
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.1) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
            self.imageDidChange()
//            print("keyboard___hide_#3")
        }
    }
    
    // MARK: - Lowercase Category Text Field
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // UMBAU 2.0
//        if let text:String = categoryTextField.text {
//            DispatchQueue.main.async {
////                self.categoryTextField.text = text.lowercased()
//            }
        if let text:String = companyNameTextfield.text {
            DispatchQueue.main.async {
                self.companyNameTextfield.text = text.lowercased()
            }
        }
    }
    
    // MARK: - View Stuff
    func emailIsValid(email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if valid {
            valid = !email.contains("Invalid email id")
        }
        return valid
    }
    
    
    func checkInternet() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.yeahConnection()
                }
            } else {
                DispatchQueue.main.async {
                    self.noConnection()
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func yeahConnection() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear) {
            
        } completion: { (_) in
            self.notInternetView.frame.origin.y = -250
            self.notInternetView.isHidden = true
        }

    }
    
    func noConnection() {
        notInternetView.frame.origin.y = -250
        let notImageOfInternet = UIImage(systemName: "wifi.slash")
        notInternetImage.image = notImageOfInternet
        notInternetImage.tintColor = buttonColor
        notInternetLabel.lineBreakMode = .byWordWrapping
        notInternetLabel.textAlignment = .center
        notInternetLabel.text = "Keine Internetverbindung! \nBitte prüfe dein Netzwerk"
        notInternetView.isHidden = false
        notConfirmToShare()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notInternetView.frame.origin.y = self.notInternetViewY
        } completion: { (_) in
            
        }

    }
    
    func motionOptionDefaultPosition() {
        print("milkLOGIN öööö_____ \(milkLoginView.isHidden.description)")
        // UMBAU 2.0
//        toolBar.isHidden = true
        
//        milkLoginView.isHidden = true
        
        // UMBAU 2.0
//        toolBarX = toolBar.frame.origin.x
//        toolBarY = toolBar.frame.origin.y
        
//        loginViewX = milkLoginView.frame.origin.x
//        loginViewY = milkLoginView.frame.origin.y
        
        print("milkCenter ----ÄÄÄ---- \(milkLoginView.center.x)")
//        milkLoginView.frame.origin.x = milkLoginView.center.x/2
//        milkLoginView.frame.origin.y = defaultToolBarY
        
        // UMBAU 2.0
//        toolBar.translatesAutoresizingMaskIntoConstraints = true
//        toolBar.frame.origin.x = defaultToolBarX
//        toolBar.frame.origin.y = defaultToolBarY
        
    }
    
    func constraintCard() {
        
        // UMBAU 2.0
//        let cardFrameHigh = mainImageView.frame.height
//        print("cardFrameHigh --------!!!!!!:::::: \(mainImageView.frame)")
        
        
//        milkLoginView.translatesAutoresizingMaskIntoConstraints = true
        
        // UMBAU 2.0
//        if cardFrameHigh <= 196 {
//            // UMBAU 2.0
////            cardTopConstraint.constant = 10
//
//        } else if cardFrameHigh <= 429 {
//            photoLabelTopConstraint.constant = 10
//            viewPhotoLabelConstraint.constant = 10
//
//            // UMBAU 2.0
////            cardTopConstraint.constant = 26
//
//            print("funktoniert ------ der ------- test -----")
//        } else if cardFrameHigh <= 452 {
//            // UMBAU 2.0
////            cardTopConstraint.constant = 40
//
//        }
    }
    
    func dataProfileCheck() {
        
        underlineForCompanyName.isHidden = true
        editPhotoButton.alpha = 0.0
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 1.5) {
                self.mainSettingView.isHidden = false

                // UMBAU 2.0
    //            self.leaingConstraint.constant -= 292
                self.mainSettingView.frame.origin.x -= 330.0

                self.editButtonNotify()
                self.editPhotoButton.alpha = 1.0
            }
        }
        
//        UIView.animate(withDuration: 1.5, delay: 0.25, options: .curveEaseIn) {
//            self.mainSettingView.isHidden = false
//
//            // UMBAU 2.0
////            self.leaingConstraint.constant -= 292
//            self.mainSettingView.frame.origin.x -= 330.0
//
//            self.editButtonNotify()
//            self.editPhotoButton.alpha = 1.0
//        } completion: { (_) in
//
//
//        }
        
        print("____''''____countryCode \(countryCodesTextField.text?.count) && phone \(phoneTextField.text?.count == 0) && mobilePhone \(mobilePhoneTextField.text?.count)")
        
//        let data = countryCodesTextField.text?.count == 0 && phoneTextField.text?.count == 0 && mobilePhoneTextField.text?.count == 0
//
//        if data {
//            mainSettingView.isHidden = false
//            UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseIn) {
//                self.leaingConstraint.constant += 300
//            } completion: { (_) in
//                self.editButtonNotify()
//
//            }
//
//        }
        
    }
    
    func editButtonNotify() {
        editPhotoButton.isHidden = false
        editPhotoButton.backgroundColor = .clear
        editPhotoButton.layer.cornerRadius = 5
        editPhotoButton.clipsToBounds = true
        editPhotoButton.tintColor = buttonColor
        editPhotoButton.layer.borderColor = editPhotoButton.tintColor.cgColor
        editPhotoButton.layer.borderWidth = 2
        editPhotoButton.setTitle("Kontakt & Adresse hinterlegen", for: .normal)
    }
    
    func abortAndShareButtonRules() {
        
        // UMBAU 2.0
//        let imageShare = UIImage(systemName: "paperplane")
//        shareButton.setImage(imageShare, for: .normal)
//        shareButton.imageView?.tintColor = darkgrayButtonColor
//        shareButton.layer.borderWidth = 0
//        shareButton.backgroundColor = .clear
//        shareButton.isEnabled = false
//
//        abortButton.tintColor = darkgrayButtonColor
//        abortButton.layer.borderWidth = 0
//        abortButton.backgroundColor = .clear
//        abortButton.isEnabled = false
//        print("test bei touches---------------")
    }
    
    func addTargetToCountryCode() {
        countryCodesTextField.addTarget(self, action: #selector(chooseCountryCode), for: .editingChanged)
    }
    
    func blurEffectLogout() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = logoutOutlet.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logoutOutlet.addSubview(blurEffectView)
    }
    
    func radiusButtonEnabled() {
        buttonRadius25.isEnabled = true
        clearRadius25()
        buttonRadius50.isEnabled = true
        clearRadius50()
        buttonRadius100.isEnabled = true
        clearRadius100()
        buttonRadius200.isEnabled = true
        clearRadius200()
    }
    
    func radius25Tapped() {
        buttonRadius25.layer.borderWidth = 3
        buttonRadius25.tintColor = buttonColor
        buttonRadius25.layer.borderColor = buttonRadius25.tintColor.cgColor
        buttonRadius25.backgroundColor = .white
        buttonRadius25.setTitleColor(buttonColor, for: .normal)
    }
    
    func radius50Tapped() {
        buttonRadius50.layer.borderWidth = 3
        buttonRadius50.tintColor = buttonColor
        buttonRadius50.layer.borderColor = buttonRadius50.tintColor.cgColor
        buttonRadius50.backgroundColor = .white
        buttonRadius50.setTitleColor(buttonColor, for: .normal)
    }
    
    func radius100Tapped() {
        buttonRadius100.layer.borderWidth = 3
        buttonRadius100.tintColor = buttonColor
        buttonRadius100.layer.borderColor = buttonRadius100.tintColor.cgColor
        buttonRadius100.backgroundColor = .white
        buttonRadius100.setTitleColor(buttonColor, for: .normal)
    }
    
    func radius200Tapped() {
        buttonRadius200.layer.borderWidth = 3
        buttonRadius200.tintColor = buttonColor
        buttonRadius200.layer.borderColor = buttonRadius200.tintColor.cgColor
        buttonRadius200.backgroundColor = .white
        buttonRadius200.setTitleColor(buttonColor, for: .normal)
    }
    
    @objc func chooseCountryCode() {
        print("nochmal der CountryCode \(countryCodesTextField.text?.count)")
        if countryCodesTextField.text?.count ?? 0 > 4 {
            radiusButtonEnabled()
            print("wer erlaubt Radius enabled ???? 1.0 ????")
        } else {
            countryCodeBottonSetup()
            notConfirmSettingButton()
            print("falsche Farbe 1")
        }
    }
    
    func addTargetToOtherSettingsTF() {
        emailTextField.addTarget(self, action: #selector(chooseSettingTF), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(chooseSettingTF), for: .editingChanged)
        mobilePhoneTextField.addTarget(self, action: #selector(chooseSettingTF), for: .editingChanged)
        countryCodesTextField.addTarget(self, action: #selector(chooseSettingTF), for: .editingChanged)
        textForEverything.addTarget(self, action: #selector(chooseSettingTF), for: .editingChanged)
        streetTextField.addTarget(self, action: #selector(choosingAddress), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(choosingAddress), for: .editingChanged)
        buttonRadius25.addTarget(self, action: #selector(chooseSettingTF), for: .touchUpInside)
        companyNameTextfield.addTarget(self, action: #selector(chooseSettingTF), for: .editingChanged)
    }
    
    @objc func chooseSettingTF() {
        if emailTextField.text?.count ?? 0>5 && countryCodesTextField.text?.count ?? 0>4 && notInternetView.isHidden == true {
            saveSettingButtonSetup()
            print("31iger ptinter 2")
        } else if phoneTextField.text?.count ?? 0>5 && countryCodesTextField.text?.count ?? 0>4 && notInternetView.isHidden == true{
            saveSettingButtonSetup()
            print("31iger ptinter 3")
        } else if mobilePhoneTextField.text?.count ?? 0>5 && countryCodesTextField.text?.count ?? 0>4 && notInternetView.isHidden == true {
            saveSettingButtonSetup()
            print("31iger ptinter 4")
//        } else if countryCodesTextField.text?.count ?? 0>4 {
//            saveSettingButtonSetup()
//
//        } else if streetTextField.text?.count ?? 0>4 && cityTextField.text?.count ?? 0>4 {
//            saveSettingButtonSetup()
        } else if textForEverything.text?.count ?? 0 > 0 {
            saveSettingButtonSetup()
        } else if companyNameTextfield.text?.count ?? 0 > 0 || cityTextField.text?.count ?? 0 > 0 {
            saveSettingButtonSetup()
        } else {
//            saveSettingButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
////            saveSettingButton.tintColor = darkgrayButtonColor
//            saveSettingButton.isEnabled = false
//            saveSettingButton.setTitle("speichern", for: .normal)
            notConfirmSettingButton()
            print("falsche Farbe 2")
        }
        let street = "Rinnigstraße 31"
        let city = "96114"
        let country = "Deutschland"
        let testZipCode = "\(street), \(city), \(country)"
//        gecodeTheAddress()
//        gecoder.geocodeAddressString(zipCode) { (placemarks, error) in
//            self.processResponse(withPlacemarks: placemarks, error: error)
//        }
        
//        guard let zipCode = countryCodesTextField.text else { return }
//        guard let streetText = streetTextField.text else { return }
////        guard let cityText = cityTextField.text else { return}
//        guard let countryText = countryTextField.text else { return }
//
//
//        let allLocationData = "\(streetText), \(zipCode), \(countryText)"
//
//        let geoCoder = CLGeocoder()
//
//        geoCoder.geocodeAddressString(allLocationData) { (placemarks, error) in
//            guard let placemarks = placemarks?.first else { return }
//            let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
//
//            self.latitude = location.latitude
//            self.longitude = location.longitude
//        }
    }
    
    func gecodeTheAddress() {
        
        guard let zipCode = countryCodesTextField.text else { return }
        guard let streetText = streetTextField.text else { return }
//        guard let cityText = cityTextField.text else { return}
        guard let countryText = countryTextField.text else { return }
        
        
        let allLocationData = "\(streetText), \(zipCode), \(countryText)"
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(allLocationData) { (placemarks, error) in
            guard let placemarks = placemarks?.first else { return }
            let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
            
            self.latitude = location.latitude
            self.longitude = location.longitude
            
            print("gecoder --2222-- \(self.latitude) ___ \(self.longitude)")
        }
        
        
    }
    
    @objc func choosingAddress() {
//        if countryCodesTextField.text?.count ?? 0>4 {
//            saveSettingButtonSetup()
//            print("31iger ptinter 5")
//
//        } else
        
        if streetTextField.text?.count ?? 0>4 && cityTextField.text?.count ?? 0>2 && countryCodesTextField.text?.count ?? 0>4 && notInternetView.isHidden == true {
            gecodeTheAddress()
            saveSettingButtonSetup()
            print("31iger ptinter 6")
        } else {
            notConfirmSettingButton()
        }
    }
    
    func textFieldSaveProtection() {
        if emailTextField.text?.count ?? 0>4 && phoneTextField.text?.count ?? 0>4 || mobilePhoneTextField.text?.count ?? 0>4 || countryCodesTextField.text?.count ?? 0>4 {
        } else if streetTextField.text?.count ?? 0>4 && cityTextField.text?.count ?? 0>4 {
        } else {
            notConfirmSettingButton()
        }
    }
    
    func centerButton() {
        // UMBAU 2.0
//        shareButtonCenter = shareButton.center
//        abortButtonCenter = abortButton.center
//
//        shareButton.center = statusTextLabel.center
//        abortButton.center = statusTextLabel.center
//
//        shareButton.backgroundColor = .clear
//        abortButton.backgroundColor = .clear
//
//        shareButton.alpha = 0
//        abortButton.alpha = 0
        
        
        statusTextLabel.alpha = 1
        activityIndicator.startAnimating()
    }
    
    func removeCenterButton() {
        // UMBAU 2.0
//        shareButton.center = shareButtonCenter
//        abortButton.center = abortButtonCenter
//
//        shareButton.alpha = 1
//        abortButton.alpha = 1
        
        statusTextLabel.alpha = 0
        statusTextLabel.text = "" 
    }
    
//    func loggedSetup() {
//        abortButton.isHidden = true
//        cameraButton.isHidden = true
//        libraryButton.isHidden = true
//        photoCollectionButton.isHidden = true
//        shareButton.isHidden = true
//
//    }
    
//    func afterLogged() {
//        abortButton.isHidden = false
//        cameraButton.isHidden = false
//        libraryButton.isHidden = false
//        photoCollectionButton.isHidden = false
//        shareButton.isHidden = false
//
//
//    }
    
    
    
    func shareButtonSetup() {
        // UMBAU 2.0
//        shareButton.isEnabled = true
//        photoChooseView.isHidden = true
//        shareButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//        shareButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
//        let imageShare = UIImage(systemName: "paperplane")
//        shareButton.setImage(imageShare, for: .normal)
//        shareButton.imageView?.tintColor = .white
//        shareButton.backgroundColor = buttonColor
//        shareButton.layer.borderWidth = 3
//        shareButton.tintColor = darkgrayButtonColor
//        shareButton.layer.borderColor = shareButton.tintColor.cgColor
//        shareButton.layer.cornerRadius = shareButton.bounds.height/2
        
    }
    
    func abortButtonSetup() {
        
        // UMBAU 2.0
//        let imageAbort = UIImage(systemName: "xmark")
//        abortButton.setImage(imageAbort, for: .normal)
//        abortButton.imageView?.tintColor = darkgrayButtonColor
//        abortButton.backgroundColor = redButtonColor
//        abortButton.layer.borderWidth = 3
//        abortButton.tintColor = darkgrayButtonColor
//        abortButton.layer.borderColor = abortButton.tintColor.cgColor
        
    }
    
    func notConfirmToShare() {
        // UMBAU 2.0
//        let imageShare = UIImage(systemName: "paperplane")
//        shareButton.setImage(imageShare, for: .normal)
//        shareButton.imageView?.tintColor = darkgrayButtonColor
////        shareButton.tintColor = darkgrayButtonColor
//        shareButton.layer.borderWidth = 0
//        shareButton.backgroundColor = .clear
//        shareButton.isEnabled = false
    }
    
    func notConfirmSettingButton() {
        saveSettingButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        saveSettingButton.tintColor = darkgrayButtonColor
        saveSettingButton.layer.borderColor = saveSettingButton.tintColor.cgColor
        saveSettingButton.setTitleColor(darkgrayButtonColor, for: .normal)
        print("saveSettingButton =1 false")
        saveSettingButton.isEnabled = false
        saveSettingButton.layer.cornerRadius = saveSettingButton.bounds.height/2
        
        saveSettingButton.setTitle("Speichern", for: .normal)
        saveSettingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
    }
    
    func inValidEmail() {
        saveSettingButton.backgroundColor = redButtonColor
        saveSettingButton.layer.borderWidth = 4
        saveSettingButton.tintColor = darkgrayButtonColor
        saveSettingButton.layer.borderColor = saveSettingButton.tintColor.cgColor
        saveSettingButton.layer.cornerRadius = saveSettingButton.bounds.height/2
        print("saveSettingButton =2 false")
        saveSettingButton.isEnabled = false
        saveSettingButton.titleLabel?.lineBreakMode = .byWordWrapping
        saveSettingButton.titleLabel?.textAlignment = .center
        saveSettingButton.setTitle("Ungültige Email", for: .normal)
        saveSettingButton.setTitleColor(darkgrayButtonColor, for: .normal)
        print("Setting test __ Invalid_2__ ")
    }
    
    func saveSettingButtonSetup() {
        saveSettingButton.isEnabled = true
        print("saveSettingButton =1 true")
//        saveSettingButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//        saveSettingButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        saveSettingButton.layer.borderWidth = 4
        saveSettingButton.tintColor = buttonColor
        saveSettingButton.layer.borderColor = saveSettingButton.tintColor.cgColor
        saveSettingButton.backgroundColor = .white
        saveSettingButton.setTitleColor(buttonColor, for: .normal)
        saveSettingButton.setTitle("Speichern", for: .normal)
        print("bist du der 31iger")
    }
    
    func saveSettingProtection() {
        print("radiusChoosed Protection -> \(radiusChoosed)")
        if countryCodesTextField.text!.count > 4 && radiusChoosed != 0.0 && notInternetView.isHidden == true {
            saveSettingButtonSetup()
            print("31iger ptinter 1")
        }
        
    }
    
    //-> Alpha Wert für aktuellen button text brauchen wir nicht, falls doch -> Lektion 60
    //    func handleSharAbortButton() {
    //        let attributedShareButtonText = NSAttributedString(string: shareButton.currentTitle!, attributes: [NSAttributedString])
    //    }
    
    func setupStatusTextLabel() {
        statusTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
        statusTextLabel.lineBreakMode = .byWordWrapping
        statusTextLabel.textAlignment = .center
    }
    
    func wrongStatusTextLabelUpload() {
        statusTextLabel.backgroundColor = .purple
        statusTextLabel.text = "fehler \nbeim laden"
    }
    
    func loadSaveButton() {
//        saveSettingButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//        saveSettingButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        saveSettingButton.backgroundColor = .white
        saveSettingButton.setTitle(" ", for: .normal)
        activityIndicatorSetting.startAnimating()
        
    }
    
    func successfulDataUpload() {
        activityIndicatorSetting.stopAnimating()
        saveSettingButton.titleLabel?.lineBreakMode = .byWordWrapping
        saveSettingButton.titleLabel?.textAlignment = .center
        saveSettingButton.setTitle("Daten \ngeladen", for: .normal)
        saveSettingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        print("saveSettingButton =3 false")
        saveSettingButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.notConfirmSettingButton()
        }
        print("Adresse ist -1- lat \(latitude) && long \(longitude)")
        if latitude == nil || longitude == nil {
            print("Adresse ist nil")
        } else if latitude == 0.0 || longitude == 0.0 {
            print("Adresse ist 0.0")
        }
        
    }
    
    func removeSettings() {
//        saveSettingButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
////        saveSettingButton.tintColor = darkgrayButtonColor
//        saveSettingButton.layer.cornerRadius = saveSettingButton.bounds.height/2
//        saveSettingButton.tintColor = .white
//        saveSettingButton.isEnabled = false
//        saveSettingButton.setTitle("speichern", for: .normal)
        notConfirmSettingButton()
        print("falsche Farbe 3")
    }
    
    func mistakeSaveButton() {
        saveSettingButton.backgroundColor = redButtonColor
        saveSettingButton.tintColor = darkgrayButtonColor
        saveSettingButton.layer.borderColor = saveSettingButton.tintColor.cgColor
        saveSettingButton.titleLabel?.lineBreakMode = .byWordWrapping
        saveSettingButton.titleLabel?.textAlignment = .center
        saveSettingButton.setTitleColor(darkgrayButtonColor, for: .normal)
        saveSettingButton.setTitle("upload fehler", for: .normal)
        saveSettingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        saveSettingButton.isEnabled = false
        print("saveSettingButton =4 false")
        
    }

    func imageDidChange() {
        // UMBAU 2.0
//        let isImage = selectedImage != nil && categoryTextField.text?.count ?? 0 > 0 && notInternetView.isHidden == true
//        let secondImage = newImageForCard != nil && categoryTextField.text?.count ?? 0 > 0 && notInternetView.isHidden == true
//        let between = selectedImage != nil || newImageForCard != nil  // || categoryTextField.text?.count ?? 0 > 0
        let checkCompanyImage = selectedCompanyImage != nil && notInternetView.isHidden == true

//        if isImage {
//            shareButtonSetup()
//
////            notConfirmToShare()
//            abortButton.isEnabled = true
//            abortButtonSetup()
//            print("punkt111")
//        } else if secondImage {
//            shareButtonSetup()
////            notConfirmToShare()
//            abortButton.isEnabled = true
//            abortButtonSetup()
//            print("punkt222")
//        } else if between {
//            notConfirmToShare()
//            photoChooseView.isHidden = true
////            shareButtonSetup()
//            abortButton.isEnabled = true
//            print("punkt333")
//            abortButtonSetup()
        if checkCompanyImage {
            saveSettingButtonSetup()
            print("31iger ptinter 7")
            print("punkt444")
        }
////            abortAndShareButtonRules()
////            notConfirmToShare()
//            print("punkt555")
//        }
        
    }
    
    func checkUpload() {
        
        // UMBAU 2.0
//        let isImage = selectedImage != nil && categoryTextField.text?.count ?? 0 > 0 && notInternetView.isHidden == true
//        let secondImage = newImageForCard != nil && categoryTextField.text?.count ?? 0 > 0 && notInternetView.isHidden == true
//
//        if isImage {
//            confirmEnterOfKeyboard()
//        } else if secondImage {
//            confirmEnterOfKeyboard()
//        }
    }
    
    func addTargetToTextField() {
        // UMBAU 2.0
//        categoryTextField.addTarget(self, action: #selector(categoryDidChange), for: .editingChanged)
    }

    @objc func categoryDidChange() {
        // UMBAU 2.0
//        let isImage = selectedImage != nil && categoryTextField.text?.count ?? 0 > 0 && notInternetView.isHidden == true
//        let allThree = selectedImage != nil || categoryTextField.text?.count ?? 0 > 0
//
//        if isImage {
//            shareButtonSetup()
//            photoChooseView.isHidden = true
////            notConfirmToShare()
//            abortButton.isEnabled = true
//            abortButtonSetup()
//            print("text 111")
//
//        } else if allThree {
////            shareButtonSetup()
//
//            notConfirmToShare()
//            abortButton.isEnabled = true
//            abortButtonSetup()
//            print("text 222")
//        } else {
//            abortAndShareButtonRules()
//            print("text 444")
//        }
    }
    
    // MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        // UMBAU 2.0
//        self.leaingConstraint.constant = +292
        if mainSettingView.frame.origin.x == 60.0 {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
                self.mainSettingView.frame.origin.x += 330.0
                self.collectionView.isUserInteractionEnabled = true
                self.scrollView.isUserInteractionEnabled = false
                self.mainSettingView.isUserInteractionEnabled = false
            } completion: { (end) in
                self.mainSettingView.isHidden = true
            }
        }
        
        print("wo ist das menue --> TouchesBegan <-- \(self.mainSettingView.frame.origin.x) && breite \(self.mainSettingView.frame.width)")
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            // UMBAU 2.0
//            self.categoryTextField.isEnabled = true
            self.addTapGestureImageView()
        }
        
        if saveSettingButton.titleLabel?.font == UIFont.boldSystemFont(ofSize: 14) {
            removeSettings()
            // UMBAU 2.0
//            self.leaingConstraint.constant = +292
            self.mainSettingView.frame.origin.x += 330
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }

        }
        
//        if statusTextLabel.text == "erfolgreich \ngeladen" {
//            UIView.animate(withDuration: 0.4) {
//                print("default layout settings ----- abort Button --1111")
//                self.abortAndShareButtonRules()
////                self.removeCenterButton()
//            }
//        } else if saveSettingButton.titleLabel?.font == UIFont.boldSystemFont(ofSize: 14) {
//            removeSettings()
//            self.leaingConstraint.constant = +300
//            UIView.animate(withDuration: 0.5) {
//                self.view.layoutIfNeeded()
//            }
//        }
    }
    
    // MARK: - View Setup
    
    func checkmarkErrorImage() {
        let errorImage = UIImage(systemName: "xmark")
        imageCheckmark.image = errorImage
        imageCheckmark.tintColor = redButtonColor
        checkLoginLabel.font.withSize(15)
        checkLoginLabel.text = "Fehler Upload"
    }
    
    func checkmarkSuccessImage() {
        let successImage = UIImage(systemName: "checkmark")
        imageCheckmark.image = successImage
        imageCheckmark.tintColor = buttonColor
        checkLoginLabel.font = checkLoginLabel.font.withSize(14)
        checkLoginLabel.text = "Upload Erfolgreich"
    }
    
    func galleryButtonEnable() {
        galleryButton.layer.cornerRadius = galleryButton.bounds.width / 2
        galleryButton.clipsToBounds = true
        galleryButton.imageView?.tintColor = buttonColor
        galleryButton.backgroundColor = .white
        galleryButton.layer.borderWidth = 2
        galleryButton.tintColor = buttonColor
        galleryButton.layer.borderColor = galleryButton.tintColor.cgColor
        galleryButton.isEnabled = true
    }
    
    func galleryButtonNotEnable() {
        galleryButton.imageView?.tintColor = darkgrayButtonColor
        galleryButton.layer.cornerRadius = galleryButton.bounds.width / 2
        galleryButton.clipsToBounds = true
        galleryButton.layer.borderWidth = 0
        galleryButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        galleryButton.isEnabled = false
    }
    
    func setupView() {
        
        //galleryButtonEnable()
        galleryButtonNotEnable()
        
        camerButton.layer.cornerRadius = camerButton.bounds.width / 2
        camerButton.clipsToBounds = true
        camerButton.imageView?.tintColor = buttonColor
        camerButton.backgroundColor = .white
        camerButton.layer.borderWidth = 2
        camerButton.tintColor = buttonColor
        camerButton.layer.borderColor = camerButton.tintColor.cgColor
        
        
        let blurEffectToolBar = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        let blurEffectToolBarView = UIVisualEffectView(effect: blurEffectToolBar)
        blurEffectToolBarView.frame = toolBarViewBlur.bounds
        blurEffectToolBarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toolBarViewBlur.addSubview(blurEffectToolBarView)
        toolBarViewBlur.layer.cornerRadius = 10
        toolBarViewBlur.clipsToBounds = true
        toolBarViewBlur.backgroundColor = .clear
        toolBarView.backgroundColor = .clear
        toolBarView.layer.cornerRadius = 10
        toolBarView.clipsToBounds = true
        
        
        notInternetView.layer.cornerRadius = 5
        
        editPhotoButton.isEnabled = false
        editPhotoButton.isHidden = true
        underlineForCompanyName.isHidden = false
        //        mainImageView.layer.cornerRadius = 20
        
        // UMBAU 2.0
//        mainImageView.contentMode = UIView.ContentMode.scaleAspectFit
//        mainImageView.clipsToBounds = true
        
        
        //        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        //        view.addSubview(mainImageView)
        
        let cardImage = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cardImage.clipsToBounds = false
        cardImage.layer.shadowColor = UIColor.black.cgColor
        cardImage.layer.shadowOpacity = 1
        cardImage.layer.shadowOffset = CGSize.zero
        cardImage.layer.shadowRadius = 10
        cardImage.layer.shadowPath = UIBezierPath(roundedRect: cardImage.bounds, cornerRadius: 10).cgPath
        
        locationPinImage.image = UIImage(systemName: "location.fill")
        locationPinImage.contentMode = .scaleAspectFill
//        locationPinImage.image?.size = CGSize(width: 10, height: 10)
        locationPinImage.tintColor = redButtonColor
        locationPinImage.backgroundColor = .clear
//        locationPinImage.layer.borderWidth = 2
//        locationPinImage.tintColor = darkgrayButtonColor
//        locationPinImage.layer.borderColor = locationPinImage.tintColor.cgColor
//        locationPinImage.layer.cornerRadius = locationPinImage.bounds.height/2
        
        
//        cardImageView.layer.cornerRadius = 20
//        cardImageView.layer.shadowColor = UIColor.black.cgColor
//        cardImageView.layer.shadowOffset = .zero
//        cardImageView.layer.shadowRadius = 10
//        cardImageView.layer.shadowOpacity = 1.0
//        //cardImageView.backgroundColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1.0)
//        cardImageView.backgroundColor = .white
//        cardImageView.clipsToBounds = true
        
        
        // UMBAU 2.0
//        shareButton.backgroundColor = .clear
//        shareButton.layer.cornerRadius = shareButton.bounds.height/2
//        shareButton.tintColor = darkgrayButtonColor
//        shareButton.isEnabled = false
        
        
//        let imageShare = UIImage(systemName: "paperplane")
        
//        abortButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        
        // UMBAU 2.0
//        abortButton.backgroundColor = .clear
//        abortButton.layer.cornerRadius = shareButton.bounds.height/2
//        abortButton.tintColor = darkgrayButtonColor
        
        
//        abortButton.layer.borderWidth = 2
//        abortButton.layer.borderColor = abortButton.tintColor.cgColor
        
        // UMBAU 2.0
//        abortButton.isEnabled = false
//        let imageCamera = UIImage(systemName: "camera")
//        cameraButton.setImage(imageCamera, for: .normal)
//        cameraButton.imageView?.tintColor = buttonColor
//        cameraButton.backgroundColor = .white
//        cameraButton.layer.borderWidth = 3
//        cameraButton.tintColor = buttonColor
//        cameraButton.layer.borderColor = cameraButton.tintColor.cgColor
//        cameraButton.layer.cornerRadius = cameraButton.bounds.height/2
        
        
        
        secondLoginView.backgroundColor = .clear
        
        let blurEffectLogin = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectLoginView = UIVisualEffectView(effect: blurEffectLogin)
        
        blurEffectLoginView.frame = secondLoginView.bounds
        blurEffectLoginView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        secondLoginView.addSubview(blurEffectLoginView)
        milkLoginView.layer.cornerRadius = 10
        milkLoginView.clipsToBounds = true
        milkLoginView.backgroundColor = .clear
        
        // checkmark
        // xmark
        
        // UMBAU 2.0
//        let imageLibrary = UIImage(systemName: "plus")
//        libraryButton.setImage(imageLibrary, for: .normal)
//        libraryButton.imageView?.tintColor = buttonColor
//        libraryButton.backgroundColor = .white
//        libraryButton.layer.borderWidth = 3
//        libraryButton.tintColor = buttonColor
//        libraryButton.layer.borderColor = libraryButton.tintColor.cgColor
//        libraryButton.layer.cornerRadius = libraryButton.bounds.height/2
//        let imagePhotoColl = UIImage(systemName: "photo")
//        photoCollectionButton.setImage(imagePhotoColl, for: .normal)
//        photoCollectionButton.imageView?.tintColor = buttonColor
//        photoCollectionButton.backgroundColor = .white
//        photoCollectionButton.layer.borderWidth = 3
//        photoCollectionButton.tintColor = buttonColor
//        photoCollectionButton.layer.borderColor = photoCollectionButton.tintColor.cgColor
//        photoCollectionButton.layer.cornerRadius = photoCollectionButton.bounds.height/2
//        let blurEffectToolBar = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
//        let blurEffectToolBarView = UIVisualEffectView(effect: blurEffectToolBar)
//        blurEffectToolBarView.frame = toolBarBlurEffect.bounds
//        blurEffectToolBarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        toolBarBlurEffect.addSubview(blurEffectToolBarView)
//        toolBarBlurEffect.layer.cornerRadius = 10
//        toolBarBlurEffect.clipsToBounds = true
//        toolBarBlurEffect.backgroundColor = .clear
//        toolBar.layer.cornerRadius = 10
//        toolBar.clipsToBounds = true
//        toolBar.backgroundColor = .clear
        
        
        statusTextLabel.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
        statusTextLabel.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        statusTextLabel.layer.cornerRadius = statusTextLabel.bounds.height/2
        statusTextLabel.alpha = 0.0
        
        // UMBAU 2.0
//        categoryTextField.returnKeyType = .send
//        categoryTextField.tintColor = UIColor.black
        
        
        
//        categoryTextField.placeholder = "deine produktbeschreibung"
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let placeholderText = NSAttributedString(string: "Beschreibung hinterlegen", attributes: attribute)
        let placeholderMobilePhone = NSAttributedString(string: "Mobilfunknummer", attributes: attribute)
        let placeholderPhone = NSAttributedString(string: "Festnetznummer", attributes: attribute)
        let placeholderEmail = NSAttributedString(string: "E-mail", attributes: attribute)
        let placeholderCountryCode = NSAttributedString(string: "Postleitzahl", attributes: attribute)
        let placeholderCompanyName = NSAttributedString(string: "Unternehmen", attributes: attribute)
        let placeholderStreetName = NSAttributedString(string: "Straße", attributes: attribute)
        let placeholderCityName = NSAttributedString(string: "Ort", attributes: attribute)
        let placeholderTextForEverything = NSAttributedString(string: "Text für alles andere", attributes: attribute)
        
        // UMBAU 2.0
//        categoryTextField.attributedPlaceholder = placeholderText
        
        
//        homepageTextField.attributedPlaceholder = placeholderHompage
        mobilePhoneTextField.attributedPlaceholder = placeholderMobilePhone
        phoneTextField.attributedPlaceholder = placeholderPhone
        emailTextField.attributedPlaceholder = placeholderEmail
        countryCodesTextField.attributedPlaceholder = placeholderCountryCode
        companyNameTextfield.attributedPlaceholder = placeholderCompanyName
        streetTextField.attributedPlaceholder = placeholderStreetName
        cityTextField.attributedPlaceholder = placeholderCityName
        textForEverything.attributedPlaceholder = placeholderTextForEverything
        
        
        countryTextField.text = "Deutschland"
        countryTextField.tintColor = .white
        countryTextField.isEnabled = false
        
//        categoryTextField.textColor = UIColor.black
//        categoryTextField.text = "deine produktbeschreibung"
//        categoryTextField.text = "welche kategorie....?"
//        categoryTextField.textColor = UIColor(white: 1.9, alpha: 0.8)
//        categoryTextField.textColor = UIColor.gray
//        categoryTextField.tintColor = UIColor(white: 0.5, alpha: 0.7)
        
        logoutActivityIndiactor.isHidden = true
        logoutActivityIndiactor.stopAnimating()
        
        companyNameTextfield.textColor = .white
//        companyNameTextfield.text = "name des unternehmens"
//
        countryCodesTextField.textColor = .white
//        countryCodesTextField.placeholder = "postleitzahl"
        
        cityTextField.textColor = .white
        streetTextField.textColor = .white
//
        emailTextField.textColor = .white
//        emailTextField.placeholder = "email adresse"
//
        phoneTextField.textColor = .white
        
//        phoneTextField.placeholder = "telefonnummer"
//
        mobilePhoneTextField.textColor = .white
//        mobilePhoneTextField.placeholder = "mobile telefonnummer"
//
//        homepageTextField.textColor = .white
//        homepageTextField.placeholder = "homepage"
        
//        saveSettingButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
////        saveSettingButton.tintColor = darkgrayButtonColor
//        saveSettingButton.layer.cornerRadius = saveSettingButton.bounds.height/2
//        saveSettingButton.tintColor = .white
//        saveSettingButton.isEnabled = false
//        saveSettingButton.setTitle("speichern", for: .normal)
        notConfirmSettingButton()
        print("falsche Farbe 4")
//        companyImage.layer.cornerRadius = companyImage.bounds.height/2
        companyImage.layer.cornerRadius = companyImage.bounds.width/2
//        let blueEffectImage = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
//        let blurEffectImageView = UIVisualEffectView(effect: blueEffectImage)
//        blurEffectImageView.frame = companyImageBlur.bounds
//        blurEffectImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        companyImageBlur.addSubview(blurEffectImageView)
//        companyImageBlur.layer.cornerRadius = 10
//        companyImageBlur.clipsToBounds = true
//        companyImageBlur.backgroundColor = .clear
        succeedLogoutSetup()
    }
    
    func succeedLogoutSetup() {
        let imageLogOut = UIImage(systemName: "figure.walk")
        logoutOutlet.setImage(imageLogOut, for: .normal)
        logoutOutlet.imageView?.tintColor = darkgrayButtonColor
        logoutOutlet.layer.cornerRadius = logoutOutlet.bounds.height/2
        logoutOutlet.layer.borderWidth = 3
        logoutOutlet.tintColor = darkgrayButtonColor
        logoutOutlet.layer.borderColor = logoutOutlet.tintColor.cgColor
        logoutOutlet.clipsToBounds = true
        logoutOutlet.backgroundColor = redButtonColor
    }
    
    
    func moveToolBar() {
        // constraint Tool Bar 14
        UIView.animate(withDuration: 100.5) {
//            self.toolBarBottomConstraint.constant += 314
            
            
        }
//        UIView.animate(withDuration: 5.5, delay: 0.5, options: .curveLinear) {
//            self.toolBar.alpha = 1.1
//
//        } completion: { (_) in
////            self.toolBar.layoutIfNeeded()
//
//            self.toolBarBottomConstraint.constant += 214
//        }

    }
    
    func countryCodeFieldCheck() {
        print("schon wieder der CountryCode \(countryCodesTextField.text?.count)")
        if countryCodesTextField.text!.count > 4 {
            print("wer erlaubt Radius enabled ???? 2.0 ????")
            buttonRadius25.isEnabled = true
            clearRadius25()
            buttonRadius50.isEnabled = true
            clearRadius50()
            buttonRadius100.isEnabled = true
            clearRadius100()
            buttonRadius200.isEnabled = true
            clearRadius200()
        } else {
            buttonRadius25.isEnabled = false
            setupRadius25()
            buttonRadius50.isEnabled = false
            setupRadius50()
            buttonRadius100.isEnabled = false
            setupRadius100()
            buttonRadius200.isEnabled = false
            setupRadius200()
        }
    }
    
    func setupRadius25() {
//        buttonRadius25.layer.borderColor = buttonRadius25.tintColor.cgColor
//        buttonRadius25.tintColor = .white
//        buttonRadius25.layer.borderWidth = 0
//        buttonRadius25.backgroundColor = .darkGray
//        buttonRadius25.setTitleColor(darkgrayButtonColor, for: .normal)
//        buttonRadius25.titleLabel?.font = UIFont(name: "semibold", size: 50)
        buttonRadius25.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        buttonRadius25.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius25.layer.borderWidth = 0
    }
    
    func setupRadius50() {
//        buttonRadius50.layer.borderColor = buttonRadius50.tintColor.cgColor
//        buttonRadius50.tintColor = .white
//        buttonRadius50.layer.borderWidth = 0
//        buttonRadius50.backgroundColor = .darkGray
//        buttonRadius50.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius50.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        buttonRadius50.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius50.layer.borderWidth = 0
    }
    
    func setupRadius100() {
//        buttonRadius100.layer.borderColor = buttonRadius100.tintColor.cgColor
//        buttonRadius100.tintColor = .white
//        buttonRadius100.layer.borderWidth = 0
//        buttonRadius100.backgroundColor = .darkGray
//        buttonRadius100.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius100.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        buttonRadius100.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius100.layer.borderWidth = 0
    }
    
    func setupRadius200() {
//        buttonRadius200.layer.borderColor = buttonRadius100.tintColor.cgColor
//        buttonRadius200.tintColor = .white
//        buttonRadius200.layer.borderWidth = 0
//        buttonRadius200.backgroundColor = .darkGray
//        buttonRadius200.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius200.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        buttonRadius200.setTitleColor(darkgrayButtonColor, for: .normal)
        buttonRadius200.layer.borderWidth = 0
    }
    
    func buttonCheckIfWhite() {
        if radiusChoosed == 25.0 {
            radius25Tapped()
//            buttonRadius25.backgroundColor = .white
//            buttonRadius25.setTitleColor(.black, for: .normal)
        } else if radiusChoosed == 50.0 {
            radius50Tapped()
//            buttonRadius50.backgroundColor = .white
//            buttonRadius50.setTitleColor(.black, for: .normal)
        } else if radiusChoosed == 100.0 {
            radius100Tapped()
//            buttonRadius100.backgroundColor = .white
//            buttonRadius100.setTitleColor(.black, for: .normal)
        } else if radiusChoosed == 200.0 {
            radius200Tapped()
//            buttonRadius200.backgroundColor = .white
//            buttonRadius200.setTitleColor(.black, for: .normal)
//            radiusChoosed = 200.0
        }
    }
    
    func countryCodeBottonSetup() {
        setupRadius25()
        buttonRadius25.isEnabled = false
        buttonRadius25.layer.cornerRadius = buttonRadius25.bounds.height / 2
        
        setupRadius50()
        buttonRadius50.isEnabled = false
        buttonRadius50.layer.cornerRadius = buttonRadius50.bounds.height / 2
        
        setupRadius100()
        buttonRadius100.isEnabled = false
        buttonRadius100.layer.cornerRadius = buttonRadius100.bounds.height / 2
        
        setupRadius200()
        buttonRadius200.isEnabled = false
        buttonRadius200.layer.cornerRadius = buttonRadius200.bounds.height / 2
    }
    
    func clearRadius25() {
        buttonRadius25.layer.borderWidth = 3
        buttonRadius25.tintColor = .white
        buttonRadius25.layer.borderColor = buttonRadius25.tintColor.cgColor
        buttonRadius25.backgroundColor = .clear
        buttonRadius25.setTitleColor(.white, for: .normal)
    }
    
    func clearRadius50() {
        buttonRadius50.layer.borderWidth = 3
        buttonRadius50.tintColor = .white
        buttonRadius50.layer.borderColor = buttonRadius50.tintColor.cgColor
        buttonRadius50.backgroundColor = .clear
        buttonRadius50.setTitleColor(.white, for: .normal)
    }
    
    func clearRadius100() {
        buttonRadius100.layer.borderWidth = 3
        buttonRadius100.tintColor = .white
        buttonRadius100.layer.borderColor = buttonRadius100.tintColor.cgColor
        buttonRadius100.backgroundColor = .clear
        buttonRadius100.setTitleColor(.white, for: .normal)
    }
    
    func clearRadius200() {
        buttonRadius200.layer.borderWidth = 3
        buttonRadius200.tintColor = .white
        buttonRadius200.layer.borderColor = buttonRadius200.tintColor.cgColor
        buttonRadius200.backgroundColor = .clear
        buttonRadius200.setTitleColor(.white, for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentCharacter = countryCodesTextField.text?.count ?? 0
//        if range.length + range.location > currentCharacter {
//            return false
//        }
//        let newLength = currentCharacter + string.count - range.length
        
        var maxLength: Int
        if textField.isEqual(countryCodesTextField)  {
            maxLength = 5
            print("grenze zeichen 5er---")
        } else {
            maxLength = 150
            print("grenze zeichen 1er---")
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
        
        
//        return newString <= maxLength
    }
    

    
    // MARK: - Pinch Post Photo
    @IBAction func scalePiese(_ gestureRecognizer: UIPinchGestureRecognizer) {
        print("zoom-scale -test- \(gestureRecognizer.scale)")
        
        // UMBAU 2.0
//        if gestureRecognizer.state == .ended {
//            UIView.animate(withDuration: 0.2) {
//                self.mainImageView.transform = CGAffineTransform.identity
//            }
//        } else if mainImageView.transform.a >= 1.0 && mainImageView.transform.d >= 1.0 {
//            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
//            gestureRecognizer.scale = 1.0
//        }
        
//        if mainImageView.transform.a >= 1.0 && mainImageView.transform.d >= 1.0 {
//            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
//            gestureRecognizer.scale = 1.0
//        }
    }
    
    @objc func panGesture(panGesture: UIPanGestureRecognizer) {
        let piece = panGesture.view!
        let translation = panGesture.translation(in: piece.superview)
        if panGesture.state == .began {
            self.initialCenter = piece.center
        }
        if panGesture.state == .ended {
            piece.center = initialCenter
        } else if panGesture.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
    }
    
    // MARK: - Confirm Keyboard Upload
    
    func confirmEnterOfKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.4) {
//            self.centerButton()
        }
        shareStarts()
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let imageId = NSUUID().uuidString // Jede Foto erhält seine einmalige ID
        
        let storageRef = Storage.storage().reference().child("posts").child(imageId)
        storagePostTheId = imageId
        print("postStorageId -- \(storagePostTheId) --")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.wrongStatusTextLabelUpload()
                self.setupStatusTextLabel()
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                let profilImageUrlString = url?.absoluteString
                self.uploadDataToDatabase(imageUrl: profilImageUrlString ?? "Kein Bild vorhanden")
            })
        }
    }
    
    // MARK: - Choose Post Photo

    func addTapGestureImageView() {
        
//        print("Setting_Menu____\(leaingConstraint.constant.description)")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
//        print("checkImage__ __ constant 1.o \(leaingConstraint.constant)")
        
//        if editPhotoButton.isHidden == true {
//            companyImage.isUserInteractionEnabled = false
//            photoChooseView.isUserInteractionEnabled = true
//            photoChooseView.addGestureRecognizer(tapGesture)
//            print("editPhotoProblem --> isHidden == true")
//        } else if editPhotoButton.isHidden == false {
//            photoChooseView.isUserInteractionEnabled = false
//            companyImage.isUserInteractionEnabled = true
//            companyImage.addGestureRecognizer(tapGesture)
//            print("editPhotoProblem --> isHidden == false")
//        }
        
        // UMBAU 2.0
//        if self.mainSettingView.frame.origin.x += 300 == 292.0 {
//            companyImage.isUserInteractionEnabled = false
//            photoChooseView.isUserInteractionEnabled = true
//            photoChooseView.addGestureRecognizer(tapGesture)
////            mainImageView.isUserInteractionEnabled = true
////            mainImageView.addGestureRecognizer(tapGesture)
////            print("checkImage__mainImage ====== true \(leaingConstraint.constant)")
//        } else if leaingConstraint.constant == 0.0 && editPhotoButton.isHidden == true {
//            companyImage.isUserInteractionEnabled = false
//            photoChooseView.isUserInteractionEnabled = true
//            photoChooseView.addGestureRecognizer(tapGesture)
////            print("checkImage__SECOND===== true \(leaingConstraint.constant)")
//        } else {
////            mainImageView.isUserInteractionEnabled = false
//            photoChooseView.isUserInteractionEnabled = false
//            companyImage.isUserInteractionEnabled = true
//            companyImage.addGestureRecognizer(tapGesture)
////            print("checkImage__companyImage ===== true \(leaingConstraint.constant)")
//        }
        
        
//        photoChooseView.isUserInteractionEnabled = false
        companyImage.isUserInteractionEnabled = true
        companyImage.addGestureRecognizer(tapGesture)
        

    }
    
    
    @objc func handleSelectPhoto() {
        
        // Achtung Umbau von Company Image
        
        
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.allowsEditing = true
//        print("pickerFrame ____ \(pickerController.accessibilityFrame)")
//        let cameraView = CGRect(x: 2.0, y: 183.0, width: 386, height: 543)
//        pickerController.accessibilityFrame = cameraView
//
//
//        present(pickerController, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: self.editSegue, sender: nil)
        self.performSegue(withIdentifier: "showPreviewByCompanyHome", sender: self)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let cameraView = CGRect(x: 2.0, y: 183.0, width: 386, height: 543)
//        picker.accessibilityFrame = cameraView
        
        
        print("image ????----????? \(info.debugDescription)")
//        if leaingConstraint.constant == -292.0 {
//            let originalImageCom = info[.originalImage] as? UIImage
//            selectedCompanyImage = originalImageCom
//            companyImage.image = originalImageCom
//            print("picker 1.o--------------")
////        } else if let cropRect = info[.cropRect] as? UIImage {
////            mainImageView.image = cropRect
////            selectedImage = cropRect
////            print("picker 4.o--------------")
//        } else if let editeImage = info[.editedImage] as? UIImage {
//            mainImageView.image = editeImage
////            backgroundImage.image = editeImage
//            selectedImage = editeImage
//            print("picker 4.o--------------")
//
//        } else if let originalImage = info[.originalImage] as? UIImage {
//            mainImageView.image = originalImage
////            backgroundImage.image = originalImage
//            selectedImage = originalImage
//            print("picker 2.o--------------")
//
//
//
////        } else if let editImage = info[.cropRect] as? UIImage {
////            mainImageView.image = editImage
////            backgroundImage.image = editImage
////            selectedImage = editImage
////            print("picker 3.o--------------")
//
//
//        }
//        dismiss(animated: true, completion: nil)
        
        testImage = info[.originalImage] as? UIImage

        dismiss(animated: true) {
            self.performSegue(withIdentifier: self.editSegue, sender: nil)
        }
        
        imageDidChange()
    }
    
    // MARK: - Navigation Setup
    func navigationTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)

//        let tapGestureNaviTitle = UITapGestureRecognizer(target: self, action: #selector(unwindToHomeVC))
//        label.addGestureRecognizer(tapGestureNaviTitle)
//        label.isUserInteractionEnabled = true

        return label
    }
    
    @objc func unwindToHomeVC() {
        self.mainSettingView.isHidden = true
//        performSegue(withIdentifier: "unwindToHomeVC", sender: self)
    }
    
    // MARK: - Posts
    
    // MARK: - Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        print("wo ist das menue Anfang \(mainSettingView.frame.origin.x) && breite \(mainSettingView.frame.width)")
        if self.mainSettingView.frame.origin.x == 390.0 {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) {
                self.mainSettingView.isHidden = false
                self.mainSettingView.frame.origin.x -= 330.0
                self.collectionView.isUserInteractionEnabled = false
                self.scrollView.isUserInteractionEnabled = true
                self.mainSettingView.isUserInteractionEnabled = true
            } completion: { _ in
                
            }
        } else if self.mainSettingView.frame.origin.x == 60.0 {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
                self.mainSettingView.frame.origin.x += 330.0
                self.collectionView.isUserInteractionEnabled = true
                self.scrollView.isUserInteractionEnabled = false
                self.mainSettingView.isUserInteractionEnabled = false
            } completion: { _ in
                self.mainSettingView.isHidden = true
            }
        }
        print("wo ist das menue ENDE ---> \(mainSettingView.frame.origin.x) && breite \(mainSettingView.frame.width)")
    }
    
    @IBAction func galleryButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showToEditVC", sender: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowCameraVC", sender: nil)
    }
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.4) {
//            self.centerButton()
        }
        shareStarts()
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let imageId = NSUUID().uuidString // Jede Foto erhält seine einmalige ID
        
        let storageRef = Storage.storage().reference().child("posts").child(imageId)
        storagePostTheId = imageId
        print("postStorageId -- \(storagePostTheId) --")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.wrongStatusTextLabelUpload()
                self.setupStatusTextLabel()
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                let profilImageUrlString = url?.absoluteString
                self.uploadDataToDatabase(imageUrl: profilImageUrlString ?? "Kein Bild vorhanden")
            })
        }
    }
    
    func uploadDataToDatabase(imageUrl: String) {
        let databaseRef = Database.database().reference().child("posts")
        let newPostId = databaseRef.childByAutoId().key
        let newPostReference = databaseRef.child(newPostId!)
        
        // Category Stuff
//        let textArray = categoryTextField.text
        //let newCategoryRef = CategoryApi.shared.REF_CATEGORY.child(textArray!)
//        let newCategoryRef = CategoriesApi.shared.REF_CATEGORIES.child(textArray!)
//        let dicCategory = [newPostId : true]
//        newCategoryRef.updateChildValues(dicCategory)
        
        // Test für post ID -> by error delete postId in "let dic = [blablabla]"
        let postId = newPostId
        // Test Storage Post Id
        let storagePostId = storagePostTheId
        
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        // UMBAU 2.0
//        let dic = ["uid" : userUid, "imageUrl" : imageUrl, "postText" : categoryTextField.text, "count" : "1", "postId" : postId, "storagePostId" : storagePostId] as [String : Any]
        
        let dic = ["uid" : userUid, "imageUrl" : imageUrl, "count" : "1", "postId" : postId, "storagePostId" : storagePostId] as [String : Any]
        
        newPostReference.setValue(dic) { (error, ref) in
            if error != nil {
                print("Fehler Daten konnten nicht hochgeladen werden")
                self.activityIndicator.stopAnimating()
                self.shareError()
                //self.statusTextLabel.text = "fehler \nbeim laden"
//                self.wrongStatusTextLabelUpload()
//                self.setupStatusTextLabel()
                return
            }
            PostApi.shared.REF_MY_POSTS.child(userUid).child(newPostId!).setValue(true)
//            CategoriesApi.shared.REF_MY_CATEGORIES.child(textArray!).child(userUid).child(newPostId!).setValue(true)
            print("Post wurde erstellt!")
//            self.activityIndicator.stopAnimating()
//            self.statusTextLabel.text = "erfolgreich \ngeladen"
            self.shareSuccessful()
//            self.setupStatusTextLabel()
            self.abortAndShareButtonRules()
            print("default layout settings ----- abort Button --2222")
            self.remove()
            
        }
    }
    
    
    
    @IBAction func photoCollectionButtonTapped(_ sender: UIButton) {
        milkLoginView.isHidden = true
    }
    
    
    
    @IBAction func libraryButtonTapped(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
//        pickerController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        
//        pickerController.loadViewIfNeeded()
//        print("the picker frame 1.0 \(pickerController.view.frame)")
////        print("pickerFrame ____ \(pickerController.cameraOverlayView?.frame)")
//        let cameraView = CGRect(x: 2.0, y: 183.0, width: 386, height: 543)
//        pickerController.view.frame = mainImageView.bounds
//        pickerController.view.translatesAutoresizingMaskIntoConstraints = true
//        print("the picker frame 2.0 \(pickerController.view.frame)")
////        pickerController.accessibilityFrame = cameraView
//        pickerController.loadViewIfNeeded()
        
//        pickerController.cameraOverlayView?.frame = cameraView
        
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        remove()
        abortAndShareButtonRules()
        print("default layout settings ----- abort Button --3333")
    }
    
    func remove() {
        selectedImage = nil
        
        // UMBAU 2.0
//        categoryTextField.text = ""
//        photoChooseView.isHidden = false
//        mainImageView.image = UIImage(named: "")
        
        
//        backgroundImage.image = UIImage(named: "placeholder")
    }
    
    // UMBAU 2.0
//    @IBAction func settingButtonTapped(_ sender: UIBarButtonItem) {
////        print("leaningConstrain SETTTING ______ \(self.leaingConstraint.constant.description)")
////        self.mainSettingView.isHidden = false
//////       self.mainSettingView.translatesAutoresizingMaskIntoConstraints = true
//////        self.mainSettingView.frame.origin.x -= 300
////        self.leaingConstraint.constant = -300
//        print("cardFrameHigh --------!!!!!!:::::: letzter \(mainImageView.frame)")
//        if self.leaingConstraint.constant != -292 {
//            print("Setting V1----")
//            mainSettingView.isHidden = false
//            self.leaingConstraint.constant = -292
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//                self.categoryTextField.isEnabled = false
//                self.addTapGestureImageView()
////                self.mainImageView.isUserInteractionEnabled = false
////                self.companyImage.isUserInteractionEnabled = true
//            }
//        } else {
//            print("Setting V2----")
//            self.leaingConstraint.constant = +292
//            UIView.animate(withDuration: 0.5) {
//                self.view.layoutIfNeeded()
//                self.categoryTextField.isEnabled = true
//                self.addTapGestureImageView()
////                self.mainImageView.isUserInteractionEnabled = true
////                self.companyImage.isUserInteractionEnabled = false
//
//            }
//        }
//        if emailIsValid(email: emailTextField.text!) {
//
//        } else {
//            inValidEmail()
//        }
//
//    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        blurEffectLogout()
        logoutActivityIndiactor.isHidden = false
        logoutActivityIndiactor.startAnimating()
        AuthenticationService.logOut(onSuccess: {
            
            
            UIView.animate(withDuration: 1.0, delay: 0.75, options: .curveEaseIn) {
                self.view.alpha = 0.9
            } completion: { (_) in
                self.logoutActivityIndiactor.stopAnimating()
                self.logoutActivityIndiactor.isHidden = true
                self.succeedLogoutSetup()
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginSegue")
//                self.present(loginVC, animated: true, completion: nil)
                self.tabBarController!.tabBar.items![3].isEnabled = true
                self.performSegue(withIdentifier: "unwindFromLogout", sender: self)
            }
            
        }) { (error) in
            self.logoutActivityIndiactor.stopAnimating()
            self.logoutActivityIndiactor.isHidden = true
            self.succeedLogoutSetup()
            print(error!)
        }
    }
    
    
    
    @IBAction func editPhotoButtonTapped(_ sender: UIButton) {
//        handleSelectPhoto()
    }
    
    @IBAction func saveSettingButtonTapped(_ sender: UIButton) {
        print("saveSettingButton = push")
//        gecodeTheAddress()
//        guard let zipCode = countryCodesTextField.text else { return }
//        gecoder.geocodeAddressString(zipCode) { (placemarks, error) in
//            self.processResponse(withPlacemarks: placemarks, error: error)
//        }
        
        if countryCodesTextField.text!.count <= 4 {
            countryCodesTextField.text = ""
            radiusChoosed = 0.0
        }
        print("Setting test __ 1__ \(emailTextField.text)")
        if emailIsValid(email: emailTextField.text!) {
            if let companyImageLet = self.companyImage.image, let imageData = companyImageLet.jpegData(compressionQuality: 0.1) {
                loadSaveButton()
                print("Setting test __ 2__ \(latitude), \(longitude)")
                
                guard let phone = phoneTextField.text else { return }
    //            let phone = phoneText.removeWhitspace()
                guard let mobilePhone = mobilePhoneTextField.text else { return }
    //            let mobilePhone = mobilePhoneText.removeWhitspace()
                print("Adresse ist -2- lat \(latitude) && long \(longitude)")
                print("Setting test __ 2__ \(latitude) ___ \(longitude)")
                AuthenticationService.updateUserInformation(username: companyNameTextfield.text!, email: emailTextField.text!, imageData: imageData, countryCode: countryCodesTextField.text!, latitude: latitude, longitude: longitude, street: streetTextField.text!, city: cityTextField.text!, country: countryTextField.text!, radius: radiusChoosed, phone: phone, mobilePhone: mobilePhone, textForEverything: textForEverything.text!, onSuccess: {
                    self.successfulDataUpload()
                    self.editPhotoButton.isHidden = true
                    self.underlineForCompanyName.isHidden = false
                }) { (errorMessage) in
                    self.activityIndicatorSetting.stopAnimating()
                    self.mistakeSaveButton()
                    print("Setting test __ Invalid_1__ ")
                    print(errorMessage!)
                }
            }
        } else {
            inValidEmail()
        }
        
    }
    
    @IBAction func radius25ButtonTapped(_ sender: UIButton) {
        if buttonRadius25.backgroundColor != .white {
//            buttonRadius25.backgroundColor = .white
//            buttonRadius25.setTitleColor(.black, for: .normal)
            radius25Tapped()
            clearRadius50()
            clearRadius100()
            clearRadius200()
            radiusChoosed = 25.0
            saveSettingProtection()
        } else if buttonRadius25.backgroundColor == .white {
            radiusChoosed = 0.0
            clearRadius25()
            //saveSettingProtection()
            saveSettingButtonSetup()
        }
    }
    
    @IBAction func radius50ButtonTapped(_ sender: UIButton) {
        if buttonRadius50.backgroundColor != .white {
//            buttonRadius50.backgroundColor = .white
//            buttonRadius50.setTitleColor(.black, for: .normal)
            radius50Tapped()
            clearRadius25()
            clearRadius100()
            clearRadius200()
            radiusChoosed = 50.0
            saveSettingProtection()
        } else if buttonRadius50.backgroundColor == .white {
            radiusChoosed = 0.0
            clearRadius50()
            //saveSettingProtection()
            saveSettingButtonSetup()
        }
    }
    
    @IBAction func radius100ButtonTapped(_ sender: UIButton) {
        if buttonRadius100.backgroundColor != .white {
//            buttonRadius100.backgroundColor = .white
//            buttonRadius100.setTitleColor(.black, for: .normal)
            radius100Tapped()
            clearRadius25()
            clearRadius50()
            clearRadius200()
            radiusChoosed = 100.0
            saveSettingProtection()
        } else if buttonRadius100.backgroundColor == .white {
            radiusChoosed = 0.0
            clearRadius100()
            //saveSettingProtection()
            saveSettingButtonSetup()
        }
    }
    
    @IBAction func radius200ButtonTapped(_ sender: UIButton) {
        if buttonRadius200.backgroundColor != .white {
//            buttonRadius200.backgroundColor = .white
//            buttonRadius200.setTitleColor(.black, for: .normal)
            radius200Tapped()
            clearRadius25()
            clearRadius50()
            clearRadius100()
            radiusChoosed = 200.0
            saveSettingProtection()
        } else if buttonRadius200.backgroundColor == .white {
            radiusChoosed = 0.0
            clearRadius200()
            //saveSettingProtection()
            saveSettingButtonSetup()
        }
    }
    
    @IBAction func unwindFromEditVC(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is ToEditVC {
            if let senderVC = unwindSegue.source as? ToEditVC {
                print("update Time - 4 \(senderVC.isEdited)")
                userUid = senderVC.companyPost
                collectionView.reloadData()
//                if senderVC.isEdited == true {
////                    loadCompPost()
////                    collectionView.reloadData()
//                    print("update Time")
//                } else {
//                    collectionView.reloadData()
//                }
            }
        }
    }
    
    @IBAction func unwindToCompanyVC(_ unwindSegue: UIStoryboardSegue) {
        print("funktioniert ---- angekommen")
    }
    
    @IBAction func unwindToCompanyVCSecond(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindPreviewFromCancel(_ uwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindPreviewForCompanyImage(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is PreviewViewController {
            if let senderVC = unwindSegue.source as? PreviewViewController {
                print("kommt nach nicht an \(senderVC.returnImage)")
                if senderVC.returnImage == nil {
                    companyImage.image = holdTheOldComImage
                    //companyImageBlur.image = holdTheOldComImage
                } else {
                    companyImage.image = senderVC.returnImage
                    //companyImageBlur.image = senderVC.returnImage
                    selectedCompanyImage = senderVC.returnImage
                    imageDidChange()
                }
                
            }
        }
    }
    
    @IBAction func unwindFromPreviewUserPicToCompHome(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is PreviewUserPicViewController {
            if let senderVC = unwindSegue.source as? PreviewUserPicViewController {
                if senderVC.returnImage == nil {
                    companyImage.image = holdTheOldComImage
                    //companyImageBlur.image = holdTheOldComImage
                } else {
                    companyImage.image = senderVC.returnImage
                    //companyImageBlur.image = senderVC.returnImage
                    selectedCompanyImage = senderVC.returnImage
                    imageDidChange()
                }
            }
        }
    }
    
    @IBAction func unwindPreviewToCompanyHome(_ uwindSegue: UIStoryboardSegue) {
        
        // UMBAU 2.0
//        mainImageView.image = newImageForCard
        
        
//        backgroundImage.image = newImageForCard
        selectedImage = newImageForCard
        imageDidChange()
    }
    
    
    
    
    @IBAction func unwindToCompanyHome(_ unwindSegue: UIStoryboardSegue) {
        print("-----unwind funktioniert")
        print("----- unwind \(newImageForCard.debugDescription)")
//        var image = mainImageView.image
//        image = newImageForCard
        
        // UMBAU 2.0
//        mainImageView.image = newImageForCard
//        mainImageView.clipsToBounds = true
        
        
        
//        mainImageView.contentMode = .scaleAspectFit
//        backgroundImage.image = newImageForCard
        selectedImage = newImageForCard
        imageDidChange()
    }
    
}

extension CompanyHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // UMBAU 2.0
//        if leaingConstraint.constant == +292 {
//            categoryTextField.resignFirstResponder()
//            checkUpload()
//        }
        
        companyNameTextfield.resignFirstResponder()
        emailTextField.resignFirstResponder()
//        homepageTextField.resignFirstResponder()
        
        return true
    }
}


extension CompanyHomeViewController: previewPicture {
    func imageFromTheCam(image: UIImage) {
        newImageForCard = image
        print("------Image delegaten")
    }
}

extension CompanyHomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userUid.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCompanyViewCell", for: indexPath) as! CompanyCollectionView

        cell.compPost = userUid[indexPath.row]
        cell.delegateTappedCell = self
        cell.indexRow = indexPath.row

        return cell
    }

}

extension CompanyHomeViewController: UICollectionViewDelegateFlowLayout {

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

extension CompanyHomeViewController: tappedDelegate {
    func tappedCell(indexPath: Int) {
        tappedIndex = indexPath
        print("indexForSegue -> \(indexPath)")
        performSegue(withIdentifier: "showToEditVC", sender: nil)
    }
}



