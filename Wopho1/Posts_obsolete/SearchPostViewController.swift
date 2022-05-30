//
//  SearchPostViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 27.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseDynamicLinks
import CoreData
import CoreLocation
import SDWebImage
import LinkPresentation
import MessageUI
import Network


class SearchPostViewController: UIViewController, PostCardDataSource, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var postCardCell: StackContainerPost!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var againstCounter: UILabel!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var toolBarBlur: UIView!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var textOfSearchLabel: UILabel!
    @IBOutlet weak var leftResultLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var resultSign: UIView!
    
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var noInternetImage: UIImageView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var topOfNoInternetViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewOfLastPhoto: UIView!
    
    
    @IBOutlet weak var topToolBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var topCounterConstraint: NSLayoutConstraint!
    
    
    // MARK: - var / let
    var postDelegate: PostSwipeCard?
    
    lazy var geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    var coreDataArray = [CompanyUser]()
    
    // Test redButton -> funktioniert = namen sind angepasst
    var redButton = [PostModel]()
    var countRedButton = 0
    var totalCounter = 0
    var saveId = ""
    // Ende
    
    var myTextSearch = ""
    
    // var/let Share
    var sharePostImage: UIImage!
    var imageToShare: UIImageView!
    var imageURL = URL(string: "")
    var imageString = ""
    
    var shareText = ""
    var shareImage = ""
    
    // Share methode Firebase
    var shareIDFromFirebase = ""
    var firebaseLink: URL?
    
    // UserUid for ToolBar -> Mail, Phone, Location
    var uidForToolButtons = ""
    var mail = ""
    var postTextForMail = ""
    var mobile = ""
    var phone = ""
//    var location = ""
    var latitude = 0.0
    var longitude = 0.0
    var userForToolBar = [UserModel]()
    var testCompanyName = ""
    //
    
    var notInternetViewY: CGFloat = 0
    var notInternetViewDefaultY: CGFloat = 1000
    
    // unwind from ShowVC for Company Library as a Card
    var cardPostsFromShow = [PostModel]()
    var userUidFromShowImage = ""
    
    // such ID
    var idWhereSearched: [String] = []
    var uidWhereSearched: [String] = []
    // radius Thema
    var company = [UserModel]()
    var radiusCounter = 0
    
    // gedacht nach der Radius Eingrenzung
    var cardSearchTextSecond: [String] = []
    //
    
    // Counter for Label
    var counterAgainst = 0
    // Ende
    
    var cardSearch = [PostModel]()
    var cardSearchText = ""
    
    var cardPosts = [PostModel]()
    var cardPostText = ""
    var cardPostId = ""
    
    
    
    var _radiusChoosed = 0.0
    var zipCode = ""
    var outOfRadiusIndicator = 0
    
    var swipedCard = ""
    var swipedCardText = ""
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    
    
    var coreId = "" {
        didSet {
        }
    }
    
    var topCardId = ""
    var swipedCardId = "" {
        didSet {
        }
    }
    
    var postCounter = 0
    
    // testen damit beide searchText & searchPost(Collection) an der XIP bzw. postSwipe übergeben werden
    var counter = 0
    // Ende
    
    var delegate: PostCardDelegate?
    
    
    //test der postId var f. VC CoreData abgleich
//    var savePostId = ""
    var companyArray = [CompanyUser]()
    
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupInfoUserForPic(user: _user)
        }
    }
    
    func setupInfoUserForPic(user: UserModel) {
        textOfSearchLabel.text = user.username
        guard let url = URL(string: user.companyImageUrl!) else { return }
        companyImage.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    // ENDE

    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternet()
        print("lädst du nochmal oder was ???????___\(myTextSearch)")
//        fetchUserPost()
        fetchLikePosts()
        
        notInternetViewY = noInternetView.frame.origin.y
        noInternetView.frame.origin.y = notInternetViewDefaultY
        
        print("Y____1.o \(notInternetViewY)")
        print("Y____1.oDefault \(notInternetViewDefaultY)")
        print("Y____1.oViewFrame \(noInternetView.frame.origin.y)")
        
//        textOfSearchLabel.frame.size.width = 50
//        view.layoutIfNeeded()
        
        
        textOfSearchLabel.text = myTextSearch
        
        
//        print("-----PostCardCell ----- Frame --- \(postCardCell.frame.debugDescription)")
//        print("cardSearchText >>>> \(cardSearchText)")
//        print("cardPostText >>>>>> \(cardPostText) ")
        
//        print("mein gewählter Radius ---- \(_radiusChoosed)")
//        print("mein gewählte PLZ ---- \(zipCode)")
//        loadCoreData()
        likeButtonTest()
        buttonSetup()
//        test()
//        testTwo()
//        searchResultCount()
        
        // Card Search funktioniert zurzeit nicht,testen -> 07.09
//        firstFetchCardSearch()
        // Card Serach V 25.20
        
        firstCardSearch()
        // ENDE
        cardPostSearch()
//        fetchCardSearch()
        showShareLink()
//        cardSearchTest()
        postCardCell.dataSource = self
        postCardCell.backgroundColor = .clear
        
        postCardCell.likeDelegate = self
        postCardCell.compareIdDelegate = self
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        view.isUserInteractionEnabled = true
        let panEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(edgePan:)))
        panEdgeGesture.edges = .right

        view.addGestureRecognizer(panEdgeGesture)
        
        
        
        
        view.isMultipleTouchEnabled = true

        let leftPanEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanLeftGesture(leftEdgePan:)))
        leftPanEdgeGesture.edges = .left
        view.addGestureRecognizer(leftPanEdgeGesture)
        
        
        // TEST f. postId übertragen
//        postDelegate?.delegatePostId = self
//        print("id ?????\(swipedCardId)")
        
//        print("testRedButton 1.0 -> \(self.testRedButotn.count)")
//        print("viewDidLoad cardSearchText §§§§ \(cardSearchText)")
        
        
        
        chevronLeftSetup()
//        let backButtonImage = UIImage(systemName: "chevron.left")
//        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: self, action: #selector(unwindToHome))
//        self.navigationItem.leftBarButtonItem = backButton
//        print("lädst du nochmal oder was ???????__2.o_\(cardSearchText)")
        
        print("____chevronTime")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        super.viewDidLoad()
////        fetchUserPost()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchUserPost()
    }
    
    
    
    
    // MARK: - Testbereich für backswipe
//    func gestureTest() {
//        view.isUserInteractionEnabled = true
//        view.addGestureRecognizer(UIScreenEdgePanGestureRecognizer(target: self, action: #selector(testPan2(sender:))))
//
//    }
//
//    @objc func testPan2(sender: UIScreenEdgePanGestureRecognizer) {
//        sender.edges = .right
//        print("PanScree>>>>>>>>> Number 2 funktioniert")
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        print("touchME")
//        gestureTest()
//        if test1 == 1 {
//            print("------test-----funktioniert")
//            let leftPanEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanLeftGesture(leftEdgePan:)))
//            leftPanEdgeGesture.edges = .left
//            view.isUserInteractionEnabled = true
//        } else if test2 == 1 {
//            let panEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(edgePan:)))
//            panEdgeGesture.edges = .right
//            view.addGestureRecognizer(panEdgeGesture)
//            view.isUserInteractionEnabled = true
//        }
        
        
//        if let touch = touches.first {
//            let touchLocation = touch.location(in: view)
//            print("myFinger ---- \(touchLocation)")
//        }

//        if let touch = touches.first {
//            let touchLocation = touch.location(in: view)
//            if touchLocation.x >= 100 && touchLocation.x <= 250 {
//                print("karte kommt")
//            }
//        }


    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        view.endEditing(true)
//        noConnection()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.yeahConnection()
//        }
//        print("touchME")
////        if test1 == 1 {
////            print("------test-----funktioniert")
////            leftPanEdgeGesture.edges = .left
////        } else if test2 == 1 {
////            panEdgeGesture.edges = .right
////        }
//    }
    
    // MARK: - redButton function
    func firstCardSearchLike() {
        print("redButton count \(countRedButton) && redButton ECHT \(redButton.count)")
        let redButtonLike = redButton[countRedButton]
        
        loadCoreData()
        print("test für ToolBar ___ 1.o \(redButtonLike.postText) &&& id \(redButtonLike.uid)")
        for index in companyArray {
//            print("likeCheck _redButton_TEXT \(redButtonLike.postText) ++ ID \(redButtonLike.postId)&& index_ID \(index.postUid)")
            if redButtonLike.postId == index.postUid {
                let id = redButtonLike.uid!
                let text = redButtonLike.postText!
//                print("likeCheck _ share Text bei firstCardCheck \(text) &&& and ID \(id)")
                toolBarDatas(userUid: id, text: text)
                isLikeButton()
                break
            } else {
                let id = redButtonLike.uid!
                let text = redButtonLike.postText!
                toolBarDatas(userUid: id, text: text)
                confirmLikeButton()
            }
        }
        saveId = redButtonLike.postId!
        imageString = redButtonLike.imageUrl!
        shareText = redButtonLike.postText!
        
        
    }
    
    
    func cardSearchLike() {
        countRedButton += 1
        if countRedButton == totalCounter {
            disconfirmLikeButton()
        } else if countRedButton != cardPosts.count && cardSearch.count == 0 && userUidFromShowImage.count == 0 {
            let redButtonLike = redButton[countRedButton]
            print("test für ToolBar ___ 2.o \(redButtonLike.postText) &&& id \(redButtonLike.uid)")
            for index in companyArray {
                if redButtonLike.postId == index.postUid {
                    let id = redButtonLike.uid!
                    let text = redButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    isLikeButton()
                    confirmToolButtons()
                    break
                } else {
                    let id = redButtonLike.uid!
                    let text = redButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    confirmLikeButton()
                    confirmToolButtons()
                }
            }
            saveId = redButtonLike.postId!
            imageString = redButtonLike.imageUrl!
            shareText = redButtonLike.postText!
        } else if countRedButton != cardSearch.count && cardPosts.count == 0 && userUidFromShowImage.count == 0 {
            let redButtonLike = redButton[countRedButton]
            for index in companyArray {
                if redButtonLike.postId == index.postUid {
                    let id = redButtonLike.uid!
                    let text = redButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    isLikeButton()
                    confirmToolButtons()
                    break
                } else {
                    let id = redButtonLike.uid!
                    let text = redButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    confirmLikeButton()
                    confirmToolButtons()
                }
            }
            saveId = redButtonLike.postId!
            imageString = redButtonLike.imageUrl!
            shareText = redButtonLike.postText!
            
        } else if userUidFromShowImage.count != 0 && cardPostsFromShow.count != 0 {
            let redButtonLike = redButton[countRedButton]
            for index in companyArray {
                if redButtonLike.postId == index.postUid {
                    let id = redButtonLike.uid!
                    let text = redButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    isLikeButton()
                    confirmToolButtons()
                    break
                } else {
                    let id = redButtonLike.uid!
                    let text = redButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    confirmLikeButton()
                    confirmToolButtons()
                }
            }
            saveId = redButtonLike.postId!
            imageString = redButtonLike.imageUrl!
            shareText = redButtonLike.postText!
        }
//        if countRedButton != cardPosts.count && cardSearch.count == 0 {
//            let redButtonLike = redButton[countRedButton]
//            for index in companyArray {
//                if redButtonLike.postId == index.postUid {
//                    likeButton.backgroundColor = .red
//                    break
//                }
//            }
//            saveId = redButtonLike.postId!
//        } else if countRedButton != cardSearch.count && cardPosts.count == 0 {
//            let redButtonLike = redButton[countRedButton]
//            for index in companyArray {
//                if redButtonLike.postId == index.postUid {
//                    likeButton.backgroundColor = .red
//                    break
//                }
//            }
//            saveId = redButtonLike.postId!
//        }
//        print("////RedButtonCount-- \(countRedButton)")
//        print("////totalCounter-- \(totalCounter)")
//        print("////cardPost-Count-- \(cardPosts.count)")
//        print("////cardSearch-Count-- \(cardSearch.count)")

        print("share Text bei compare Mode \(shareText) && count RedButton \(redButton.count)")
    }
    
    func backCardSearchLike() {
        print("counterAgainst back o.1>>> \(countRedButton)")
        if countRedButton != 0 {
            countRedButton -= 1
            print("counterAgainst back 1.0>>> \(countRedButton)")
            let backRedButtonLike = redButton[countRedButton]
//            likeButton.backgroundColor = UIColor(red: 227/255, green: 205/255, blue: 27/255, alpha: 1.0)
            confirmLikeButton()
            for index in companyArray {
                if backRedButtonLike.postId == index.postUid {
//                    likeButton.backgroundColor = .red
                    let id = backRedButtonLike.uid!
                    let text = backRedButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                    isLikeButton()
                    break
                } else {
                    let id = backRedButtonLike.uid!
                    let text = backRedButtonLike.postText!
                    toolBarDatas(userUid: id, text: text)
                }
            }
            saveId = backRedButtonLike.postId!
            likeButton.isEnabled = true
        }
    }
    
    // MARK: - RedButton Load - Save - Delete
    
    
    func loadCoreData() {
        let companyArray = CoreData.defaults.loadData()
        if let _companyArry = companyArray {
            self.companyArray = _companyArry
        }
    }
    func saveData() {
        if saveId.count != 0 {
            let postId = CoreData.defaults.createData(_postUid: saveId)
//            print("gespeichert")
        } else {
            errorMess()
        }
    }
    
    func errorMess() {
        let error = UIAlertController(title: "Hinweis", message: "Sammelkarte konnte nicht gespeichert werden!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Bestätigen", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    func deleteSwipeCard() {
        for index in companyArray {
//            print("vergelich if_Anweisung\(index.postUid) + \(swipedCardId)")
            if index.postUid == saveId {
                let card = index.self
                CoreData.defaults.context.delete(card)
                CoreData.defaults.saveContext()
//                likeButton.backgroundColor = UIColor(red: 227/255, green: 205/255, blue: 27/255, alpha: 1.0)
                confirmLikeButton()
//                print("buttonLike row: 127 = yellow")
//                print("gelöscht")
                break
            } else {
//                print("konnte nicht gelöscht werden in -> SearchPostVC")
            }
        }
    }
    
    
    // MARK: - functions
    
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
        confirmToolButtons()
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear) {
            
        } completion: { (_) in
            self.noInternetView.frame.origin.y = -250
            self.noInternetView.isHidden = true
        }
    }
    
    func noConnection() {
//        disconfirmToolButtons()
        print("InternetView_2.o \(noInternetView.frame.origin.y) &&& ViewY \(notInternetViewY)")
        noInternetView.frame.origin.y = -250
        let notImageOfInternet = UIImage(systemName: "wifi.slash")
        noInternetImage.image = notImageOfInternet
        noInternetImage.tintColor = truqButtonColor
        noInternetLabel.lineBreakMode = .byWordWrapping
        noInternetLabel.textAlignment = .center
        noInternetLabel.text = "Keine Internetverbindung! \nBitte prüfe dein Netzwerk"
        noInternetView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.noInternetView.frame.origin.y = self.notInternetViewY
        } completion: { (_) in
            
        }

    }
    
    
    func toolBarDatas(userUid: String, text: String) {
        UserApi.shared.observeUser(uid: userUid) { (companyData) in
            self.userForToolBar.append(companyData)
            
            self.postTextForMail = text
            
            if let _username = companyData.username {
                self.testCompanyName = _username
            } else {
                self.testCompanyName = ""
            }
//            self.testCompanyName = companyData.username!
            
            if let _mail = companyData.email {
                self.mail = _mail
            } else {
                self.mail = ""
            }
            
            if let _phone = companyData.phone {
                self.phone = _phone
            } else {
                self.phone = ""
            }
            
            if let _mobile = companyData.mobilePhone {
                self.mobile = _mobile
            } else {
                self.mobile = ""
            }
            
            if let _longitude = companyData.longitude, let _latitude = companyData.latitude {
                self.longitude = _longitude
                self.latitude = _latitude
            } else {
                self.longitude = 0
                self.latitude = 0
            }
            
            
            
            
            
//            self.mail = companyData.email!
//            self.phone = companyData.phone!
//            self.mobile = companyData.mobilePhone!
//            self.longitude = companyData.longitude!
//            self.latitude = companyData.latitude!
//            print("username für ToolBar Data test \(self.mail)")
//            print("username für ToolBar Data test \(self.phone)")
//            print("username für ToolBar Data test \(self.mobile)")
//            print("username für ToolBar Data test \(self.longitude)")
//            print("username für ToolBar Data test \(self.latitude)")
        }
    }
    
    
    func shareAPost() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/posts"
        
        let postIDQueryItem = URLQueryItem(name: "postsID", value: saveId)
        components.queryItems = [postIDQueryItem]
        print("post geteilte id saveId \(saveId)")
        
        guard let linkParameter = components.url else { return }
        print("I am sharing \(linkParameter.absoluteString)")
        
        // Create the big dynamic Link
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://wopho1.page.link") else {
            return
        }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        
        // Vorübergehende ID -> Google Photo nur zum testen
        shareLink.iOSParameters?.appStoreID = "962194608"
//        shareLink.iOSParameters?.fallbackURL
        
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.example.wopho1")
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "\(self.shareText) -> App Wopho1"
        
        guard let urlImage = URL (string: imageString) else { return }
        firebaseLink = urlImage
        shareLink.socialMetaTagParameters?.imageURL = urlImage
        
        print("ist das der lange Stringe \(imageString)")
        
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
                }
            }
            guard let url = url else { return }
            print("Ich habe eine URL zum teilen! \(url.absoluteString)")
            self?.showShareSheet(url: url)
            
        }
    }
    

    func showShareSheet(url: URL) {
        print("welche URL ist das in der func --- \(url)")
        let promoText = "\(self.shareText) -> App Wopho1"
//        let url = URL(string:􀄫 "https://firebasestorage.googleapis.com/v0/b/wopho1.appspot.com/o/posts%2FF21B33B0-38D2-47B9-93F7-812646F3199B?alt=media&token=4186d209-36fa-48e0-a1f7-3fcce0b5c99e")
        let urlSec = firebaseLink
        print("steck da kein Link ----- \(urlSec)")
        let data = try? Data(contentsOf: urlSec!)
        let image = UIImage(data: data!)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = NSItemProvider(object: image!)
        metadata.originalURL = url
        metadata.title = promoText
        
        let metadataItemSouce = LinkPresentationItemSource(metaData: metadata)
        let activity = UIActivityViewController(activityItems: [metadataItemSouce], applicationActivities: [])
        self.present(activity, animated: true)
        print("showTheSharePOPUP")
        UIView.animate(withDuration: 0.9) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        
//        let acitivityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
//        present(acitivityVC, animated: true) {
//        }
    }
    
    func mailError() {
        let error = UIAlertController(title: "Mail Programm konnte nicht geöffnet werden", message: "Bitte prüfen sie ihre Mail Einstellung", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    func successMail() {
        let _mail = MFMailComposeViewController()
        _mail.mailComposeDelegate = self
        _mail.setToRecipients([mail])
        _mail.setSubject("Anfrage Inserat aus App_Name")
        _mail.setMessageBody("Hallo, ich interessiere mich für Ihren Post >>> \(postTextForMail)", isHTML: false)
        self.present(_mail, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.mailError()
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
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
    
    
    func getPostForID(postID: String) {
        shareIDFromFirebase = postID
//        self.loadViewIfNeeded()
//        self.postCardCell.layoutIfNeeded()
//        loadView()
//        viewDidLoad()
//        print("was kommt da genau an getPostForId --START--- \(postID)")
//        viewDidLoad()
//        postCardCell.translatesAutoresizingMaskIntoConstraints = true
        
//        print("shareID nil????? 1.0 \(shareIDFromFirebase)")
//        PostApi.shared.observePost(withPodId: postID) { (post) in
//            self.cardPosts.append(post)
//            self.redButton.append(post)
//            print("start von getPostorID ////// \(self.postCardCell.debugDescription)")
//            self.postCardCell.layoutIfNeeded()
//            self.postCardCell.reloadData()
////            self.updateViewConstraints()
//            self.loadCoreData()
//
//        }
    }
    
    func loadUserInformation() {
        print("user ID ____ \(uidForToolButtons)")
        UserApi.shared.observeUser(uid: uidForToolButtons) { (id) in
            self.userForToolBar.append(id)
            if self.userForToolBar.count != 0 {
                print("Download klappt  \(self.userForToolBar.count)")
                for i in self.userForToolBar {
                    print("test für ToolBar ___ 5.o \(i.email) &&& id \(i.uid)")
                }
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    for i in self.userForToolBar {
//                        print("test für ToolBar ___ 5.o \(i.email) &&& id \(i.uid)")
//                    }
//                }
            } else {
                print("Download klappt !!! nicht !!!! \(self.userForToolBar.count)")
            }
            
        }
    }
    
    func showShareLink() {
//        print("shareID nil????? 2.0 \(shareIDFromFirebase)")
        if shareIDFromFirebase != "" {
            PostApi.shared.observePost(withPodId: shareIDFromFirebase) { (post) in
                self.cardPosts.append(post)
                self.redButton.append(post)
//                print("start von getPostorID ////// \(self.postCardCell.debugDescription)")
                self.postCardCell.layoutIfNeeded()
                self.postCardCell.reloadData()
                
    //            self.updateViewConstraints()
                self.loadCoreData()
                self.textOfSearchLabel.text = "Geteilter Inhalt"
            }
        }
    }
    
    func shareThePost() {
        
        let firstItem = shareText
        let secondItem: NSURL = NSURL(string: "https://testflight.apple.com/join/un5pvmvk")!
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [firstItem, secondItem, imageToShare as Any], applicationActivities: nil)
//        activityVC.popoverPresentationController?.sourceView = UIButton
        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityVC.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.postToTwitter]
        
        activityVC.isModalInPresentation = true
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func shareMyApp() {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let images = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out my app"
        
        if let website = URL(string: "https://testflight.apple.com/join/un5pvmvk") {
            let objectsToShare = [textToShare, website, images ?? #imageLiteral(resourceName: "Schaufenster")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.mail, UIActivity.ActivityType.message, UIActivity.ActivityType.saveToCameraRoll]
            activityVC.isModalInPresentation = true
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
//    func fetchPostIdFromLibrary() {
//        print("cardPostId ___ \(cardPostId)")
//        if cardPostId.count != 0 {
//            PostApi.shared.observePost(withPodId: cardPostId) { (id) in
//                self.cardSearch.append(id)
//                self.redButton.append(id)
//                self.postCardCell.reloadData()
//                self.loadCoreData()
//            }
//        }
//    }
    
    // MARK: - Fetch Setups
    func fetchCurrenUser() {
        UserApi.shared.observeUser(uid: userUidFromShowImage) { (uid) in
            self.user = uid
        }
    }
    
    
    // second Version of fetchCard Search
    func secondfetchCardSearch() {
        print("TableView Search __COUNT? \(uidWhereSearched.count)")
        if idWhereSearched.count != 0 {
//            print("---§§§§§---findet #1")
            print("TableView Search ______outOfRadius \(outOfRadiusIndicator) && uderUidFromShowImage \(userUidFromShowImage.count)")
            for index in idWhereSearched {
//                print("___card Search index >> \(index.debugDescription)")
//                print("___card Search radius >> \(outOfRadiusIndicator.description)")
//                print("second__index \(index)")
//                let test = index
//                PostApi.shared.observePost -> vor dem Test
                print("TableView Search __ \(index)")
                PostApi.shared.observePost(withPodId: index) { (post) in
//                    print("cardSearchTextSecon ---22--- \(self.cardSearchTextSecond.count)")
                    print("TableView Search FEHLER 1.o")
                    if self.cardSearchTextSecond.count != 0 && self.userUidFromShowImage.count == 0 {
                        print("TableView Search FEHLER")
                        for postId in self.cardSearchTextSecond {
                            if postId == post.uid {
//                                print("---§§§§§---findet #3")
//                                print("___card Search _3.o_ \(self.cardSearch.count)")
                                print("+++_ cardSearch 3.o")
                                print("TableView Search 1.o")
                                self.cardSearch.append(post)
                                self.redButton.append(post)
                                self.postCardCell.reloadData()
                                self.loadCoreData()
//                                print("cardSearchTextSecond != 0")
//                                self.disconfirmStatusCompany()
                            }
                        }
                        print("TableView Search FEHLER 2.o")
                    } else if self.outOfRadiusIndicator == 0 && self.userUidFromShowImage.count == 0 {
//                        print("___card Search _4.o_ \(self.cardSearch.count)")
                        
                        print("+++_ cardSearch 4.o >>> \(post.postText)")
                        print("TableView Search 2.o")
                        self.cardSearch.append(post)
                        self.redButton.append(post)
                        self.postCardCell.reloadData()
                        self.loadCoreData()
//                        self.disconfirmStatusCompany()
                        
//                        print("cardSearchTextSecond ----ELSE---")
                    }
                }
            }
        }
//        disconfirmStatusCompany()
    }
    
    // third Version of fetchCardSearch allerding mit gleichen namen
//    func secondfetchCardSearch1() {
//        if uidWhereSearched.count != 0 {
//            for i in uidWhereSearched {
//                if self.cardSearchTextSecond.count != 0 {
//                    for postId in self.cardSearchTextSecond {
//                        if postId == i {
//                            self.cardSearch.append(<#T##newElement: PostModel##PostModel#>)
//                        }
//                    }
//                } else {
//
//                }
//            }
//        }
//    }
//
//    func secondFetchAfter() {
//
//    }
    
    
    // first Version of fetchCardSearch
    func fetchCardSearch() {
        print("searchCardText ----1.o")
        if cardSearchText != "" {
            print("%%%%%____cardSearchText-- \(cardSearchText)")
            PostApi.shared.queryAllPost(withText: cardSearchText) { (post) in
//                print("cardSearchTextSecon ---22--- \(self.cardSearchTextSecond.count)")
                if self.cardSearchTextSecond.count != 0 {
                    for postId in self.cardSearchTextSecond {
//                        print("---§§§§§---findet #2")
                        if postId == post.uid {
//                            print("-!.-Was kommt dabei raus \(post.postText)")
                            print("___card Search _1.o_ \(post.postText)")
                            print("TableView Search 3.o")
                            self.cardSearch.append(post)
                            self.redButton.append(post)
                            self.postCardCell.reloadData()
                            self.loadCoreData()
                        }
                    }
                } else {
//                    print("-!.-Was kommt dabei raus \(post.postText)")
                    print("___card Search _2.o_ \(post.postText)")
                    print("TableView Search 4.o")
                    self.cardSearch.append(post)
                    self.redButton.append(post)
                    self.postCardCell.reloadData()
                    self.loadCoreData()
                }

                // vermutlich bei der zweiten abfragen verwenden

//                self.cardSearch.append(post)
//                self.redButton.append(post)
//                self.postCardCell.reloadData()
//                self.loadCoreData()
            }
        }
//        print("sind wir schon durch?")
    }
    // evtl. haupt - fetchCardSearch
    func firstFetchCardSearch() {
        print("searchCardText ----2.o")
        if cardSearchText != "" {
            PostApi.shared.queryAllPost(withText: cardSearchText) { (post) in
                print("postUID §§§222§§§ -- \(post.postText)")
                UserApi.shared.observeUser(uid: post.uid!) { (uid) in
//                    print("company UID - first - \(uid)")
                    self.company.append(uid)
                    self.radiusCounter += 1
                    if self.radiusCounter == self.company.count && self.zipCode != "" {
                        self.geocoderSetup()
                    }
                }
            }
        }
        if zipCode == "" {
            geocoderSetup()
        }
    }
    
    func fetchLikePosts() {
        
        if coreDataArray.count != 0 {
            self.cardPostText = "yes"
            
            for i in coreDataArray {
                let id = i.postUid!
                print("coreData ______\(i.postUid)")
                PostApi.shared.observePost(withPodId: id) { (postId) in
                    print("coreData ______\(postId.postText)")
                    self.cardPosts.append(postId)
                    self.redButton.append(postId)
                    
                    self.postCardCell.layoutIfNeeded()
                    self.postCardCell.reloadData()
                    self.loadCoreData()
//                    self.disconfirmStatusCompany()
                    
                }
            }
        }
//        disconfirmStatusCompany()
    }
    
    func fetchUserPost() {
        if userUidFromShowImage.count != 0 {
            PostApi.shared.observeMyPost(withUid: userUidFromShowImage) { (id) in
                PostApi.shared.observePost(withPodId: id) { (postId) in
                    self.cardPostsFromShow.insert(postId, at: 0)
                    self.redButton.insert(postId, at: 0)
                    
//                    self.cardPostsFromShow.append(postId)
//                    self.cardPostsFromShow.reverse()
//                    self.redButton.append(postId)
//                    self.redButton.reverse()
                    self.postCardCell.layoutIfNeeded()
                    self.postCardCell.reloadData()
                    self.loadCoreData()
                    self.confirmStatusCompany()
                    print("bist du der den ich suche")
                }
            }
        }
    }
    
    func firstCardSearch() {
        if uidWhereSearched.count != 0 {
            print("+++_ cardSearch 2.o")
            for index in uidWhereSearched {
//                print("index §§§!!§§§ \(index)")
                UserApi.shared.observeUser(uid: index) { (uid) in
//                    print("company UID - second - \(uid)")
                    self.company.append(uid)
                    self.radiusCounter += 1
                    if self.radiusCounter == self.company.count && self.zipCode != "" {
                        self.geocoderSetup()
//                        print("geocoder funktioniert ---- !! !! _____")
                    }
                }
            }
        }
        if zipCode == "" {
            geocoderSetup()
        }
    }
    
    func geocoderSetup() {
        let address = zipCode
//        print("zipCode ------ \(zipCode)")
        geocoder.geocodeAddressString(address) { (placemarks, error)
            in
//            print("zipQuery begin")
            self.processResponsers(withPlacemarks: placemarks, error: error)
            
        }
    }
    
//    func geocode() {
//        
//        let address = zipCode
//        geocoder.geocodeAddressString(address) { (placemarks, error) in
//            self.processResponse(withPlacemarks: placemarks, error: error)
//        }
//    }
    
    func cardPostSearch() {
        if cardPostText != "" {
            
            PostApi.shared.queryAllPost(withText: cardPostText) {
                (post) in
                print("+++_ Kann nicht sein")
                self.cardPosts.append(post)
                self.redButton.append(post)
                
                self.postCardCell.layoutIfNeeded()
                self.postCardCell.reloadData()
//                self.postCardCell.clipsToBounds = true
                self.loadCoreData()
    //            print("wie oft eigentlich ==== 1")
//                self.disconfirmStatusCompany()
                    }
        }
//        disconfirmStatusCompany()
        
//        PostApi.shared.queryAllPost(withText: cardPostText) { (post) in
//            self.cardPosts.append(post)
//            self.redButton.append(post)
//            self.postCardCell.reloadData()
//            self.loadCoreData()
//            print("cardPostText", post.postText)
////            print("wie oft eigentlich ==== 1")
//                }
    }
    
    // Testabteilung
//    func nochEinTest() {
//        for counter in cardPosts {
//            if counter.count != "0" {
//                postCounter += 1
//            }
//        }
//    }
    
//    func test() {
//        PostApi.shared.testPostCountSearch(withUid: cardPostId) { (post) in
//            print("test-<","\(self.cardPostId.count)")
//            self.postCount.text = "\(post)"
//        }
//    }
    
//    func testTwo() {
//        print("testTwo-------->1")
//        PostApi.shared.observePost(withPodId: cardPostId) { (post) in
//            for counter in post.count! {
//                if counter != "0" {
//                    self.postCounter += 1
//                }
//            }
//
//            self.postCount.text = "\(self.postCounter)"
//            print("postCounter°°°°°°", "\(self.postCounter)")
//            print("postCounter°°°°°°", "\(self.cardPosts.description)")
//            print("testTwo-------->2","\(self.cardPostId.description)")
////            PostApi.shared.testPostCountSearch(withUid: post.count!) { (counts) in
////                print("testTwo-------->3","\(post.count!)")
////                print("testTwo-------->4", counts.description)
////                self.postCount.text = "\(counts)"
////            }
//        }
//    }
    
//    // Done row 85 until 93 delete
//    func searchResultCount() {
//        if postCount.text == "0" {
//            postCount.text = "0"
//        } else {
//            postCount.text = cardPostId.isEmpty ?
//                NSLocalizedString("0", comment: "") :
//                String(format: NSLocalizedString("%ld", comment: ""), cardPostId.count)
//        }
//    }
    
    func likeButtonTest() {
        for index in companyArray {
            index.postUid = topCardId
        }
    }
    
    func buttonLikeCheck() {
//        for index in companyArray {
////            print("didSet postUiD->\(index.postUid) + CardId->\(swipedCardId)")
//            if index.postUid == swipedCardId {
//                likeButton.backgroundColor = .red
////                index.postUid = topCardId
////                print("red")
//            } else {
////                likeButton.backgroundColor = UIColor(red: 227/255, green: 205/255, blue: 27/255, alpha: 1.0)
////                print("gelb")
//            }
//        }
//        swipedCardId = ""
//        print("buttonLikeCheck____swipeCardId->\(swipedCardId) ==  coreId->\(coreId)")
        if swipedCardId == coreId && swipedCardId != "" && coreId != "" {
//            likeButton.backgroundColor = .red
            isLikeButton()
//            print("buttonLike row: 234 = red")
        } else {
//            likeButton.backgroundColor = UIColor(red: 227/255, green: 205/255, blue: 27/255, alpha: 1.0)
            confirmLikeButton()
//            print("buttonLike row: 238 = yellow")
        }
        
//        swipedCardId = ""
//        coreId = ""
    }
    
    func backCounterFunction() {
        counterAgainst += 1
        print("counterAgainst back 2.o>>> \(countRedButton)")
        againstCounter.text = "\(counterAgainst)"
        if counterAgainst == totalCounter {
            disconfirmBackButton()
            confirmToolButtons()
        } else if counterAgainst != 0 {
            confirmBackButton()
            confirmToolButtons()
        }
    }
    
    // MARK: - Setup
    
    func constraintCardCheck() {
        let highOfCardFrame = postCardCell.frame.height
        print("textofSearch ____ high of card frame\(highOfCardFrame)")
        if highOfCardFrame <= 429 {
            
            topCounterConstraint.constant = 40
            topToolBarConstraint.constant = 20
            
            view.layoutIfNeeded()
            print("textofSearch ____ constraint 1.o \(topCounterConstraint.constant)")
            
//            print("Karten höhe 2.o \(topToolBarConstraint.constant)")
        } else if highOfCardFrame <= 468 {
            topCounterConstraint.constant = 40
            view.layoutIfNeeded()
            print("textofSearch ____ constraint 2.o \(topCounterConstraint.constant)")
        }
    }
    
    func buttonSetup() {
        
//        topOfNoInternetViewConstraint.constant = 0
        noInternetView.layer.cornerRadius = 10
        
        
        swipedCardId = ""
        companyImage.isHidden = true
        resultSign.isHidden = false
        confirmPhoneButton()
        confirmLocationButton()
        confirmShareButton()
        confirmMailButton()
        confirmLikeButton()
        disconfirmBackButton()
        
        toolBar.layer.cornerRadius = 10
        toolBarBlur.layer.cornerRadius = 10
        postCount.clipsToBounds = true
        postCount.font = UIFont.boldSystemFont(ofSize: 15)
        postCount.textColor = truqButtonColor
        postCount.layer.cornerRadius = postCount.bounds.width/2
        postCount.layer.borderWidth = 2
        postCount.tintColor = truqButtonColor
        postCount.layer.borderColor = postCount.tintColor.cgColor
        postCount.backgroundColor = .white
        
        againstCounter.clipsToBounds = true
        againstCounter.font = UIFont.boldSystemFont(ofSize: 15)
        againstCounter.textColor = truqButtonColor
        againstCounter.layer.cornerRadius = againstCounter.bounds.width/2
        againstCounter.backgroundColor = .white
        againstCounter.layer.borderWidth = 2
        againstCounter.tintColor = truqButtonColor
        againstCounter.layer.borderColor = againstCounter.tintColor.cgColor
        againstCounter.backgroundColor = .white
        
        companyImage.layer.cornerRadius = 5
        companyImage.contentMode = .scaleAspectFill
//        backButton.layer.cornerRadius = backButton.bounds.width / 2
//        likeButton.layer.cornerRadius = likeButton.bounds.width / 2
//        postCount.layer.cornerRadius = postCount.bounds.height / 2
//        shareButton.layer.cornerRadius = shareButton.bounds.height / 2
//        shareButton.isEnabled = true
//        shareButton.backgroundColor = .blue
//        let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
//        shareButton.setImage(shareButtonImage, for: .normal)
//        shareButton.imageView?.tintColor = .white
//        shareButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
//        print("Button Setup CoreID schon vorhanden \(swipedCardId)")
//        likeButton.backgroundColor = UIColor(red: 227/255, green: 205/255, blue: 27/255, alpha: 1.0)
    }
    
    func confirmToolButtons() {
        confirmPhoneButton()
        confirmLocationButton()
        confirmShareButton()
        confirmMailButton()
    }
    
    func disconfirmToolButtons() {
        disconfirmPhoneButton()
        disconfirmLocationButton()
        disconfirmShareButton()
        disconfirmMailButton()
    }
    
    func confirmLikeButton() {
        let likeImage = UIImage(systemName: "star")
        likeButton.setImage(likeImage, for: .normal)
        likeButton.layer.cornerRadius = likeButton.bounds.width/2
        likeButton.imageView?.tintColor = .white
        likeButton.layer.borderWidth = 3
        likeButton.tintColor = darkgrayButtonColor
        likeButton.layer.borderColor = likeButton.tintColor.cgColor
        likeButton.backgroundColor = truqButtonColor
        likeButton.isEnabled = true
    }
    
    func isLikeButton() {
//        let likeImageFilled = UIImage(systemName: "star.fill")
//        likeButton.setImage(likeImageFilled, for: .normal)
        likeButton.imageView?.tintColor = darkgrayButtonColor
//        likeButton.tintColor = redColor
//        likeButton.layer.borderColor = likeButton.tintColor.cgColor
        likeButton.backgroundColor = redColor
        
        
    }
    
    func disconfirmLikeButton() {
//        let likeImage = UIImage(systemName: "star")
//        likeButton.setImage(likeImage, for: .normal)
        likeButton.imageView?.tintColor = darkgrayButtonColor
        likeButton.layer.borderWidth = 0
        likeButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        likeButton.isEnabled = false
    }
    
    func confirmBackButton() {
        let backImage = UIImage(systemName: "arrow.uturn.left")
        backButton.setImage(backImage, for: .normal)
        backButton.layer.cornerRadius = backButton.bounds.width/2
        backButton.imageView?.tintColor = .white
        backButton.layer.borderWidth = 3
        backButton.tintColor = darkgrayButtonColor
        backButton.layer.borderColor = backButton.tintColor.cgColor
        backButton.backgroundColor = truqButtonColor
        backButton.isEnabled = true
    }
    
    func disconfirmBackButton() {
        backButton.imageView?.tintColor = darkgrayButtonColor
        backButton.layer.borderWidth = 0
        backButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        backButton.isEnabled = false
    }
    
    func confirmMailButton() {
        let mailImage = UIImage(systemName: "envelope")
        mailButton.setImage(mailImage, for: .normal)
        mailButton.layer.cornerRadius = mailButton.bounds.width/2
        mailButton.imageView?.tintColor = truqButtonColor
        mailButton.backgroundColor = .white
        mailButton.layer.borderWidth = 2
        mailButton.tintColor = truqButtonColor
        mailButton.layer.borderColor = mailButton.tintColor.cgColor
        mailButton.isEnabled = true
    }
    
    func disconfirmMailButton() {
        mailButton.imageView?.tintColor = darkgrayButtonColor
        mailButton.layer.borderWidth = 0
        mailButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        mailButton.isEnabled = false
    }
    
    func confirmShareButton() {
        let shareImage = UIImage(systemName: "square.and.arrow.up.fill")
        shareButton.setImage(shareImage, for: .normal)
        shareButton.layer.cornerRadius = shareButton.bounds.width/2
        shareButton.imageView?.tintColor = truqButtonColor
        shareButton.backgroundColor = .white
        shareButton.layer.borderWidth = 2
        shareButton.tintColor = truqButtonColor
        shareButton.layer.borderColor = shareButton.tintColor.cgColor
        shareButton.isEnabled = true
    }
    
    func disconfirmShareButton() {
        shareButton.imageView?.tintColor = darkgrayButtonColor
        shareButton.layer.borderWidth = 0
        shareButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        shareButton.isEnabled = false
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
        locationButton.layer.borderWidth = 0
        locationButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        locationButton.isEnabled = false
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
        phoneButton.layer.borderWidth = 0
        phoneButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        phoneButton.isEnabled = false
    }
    
    func confirmStatusCompany() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.leftResultLabelConstraint.constant = 40
            self.companyImage.isHidden = false
            self.textOfSearchLabel.isHidden = false
            self.resultSign.isHidden = true
        }
    }
    
    func disconfirmStatusCompany() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.leftResultLabelConstraint.constant = 8
            self.companyImage.isHidden = true
            self.resultSign.isHidden = false
            self.textOfSearchLabel.isHidden = false
            print("uwnind Default__ über DISCONFIRMstatusCOMPANY \(self.textOfSearchLabel)")
        }
    }
    
    func topStatusHiddenByUnwind() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.leftResultLabelConstraint.constant = 8
            self.companyImage.isHidden = true
            self.resultSign.isHidden = true
            self.textOfSearchLabel.isHidden = true
        }
    }
    
    func chevronDownSetup() {
        let backButtonImage = UIImage(systemName: "chevron.up")
        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: self, action: #selector(unwindToHome))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func chevronLeftSetup() {
        let backButtonImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItem.Style.done, target: self, action: #selector(unwindToHome))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Screen Edge Pan Gesture
    
    @objc func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        
        if edgePan.state == .recognized {
            backCardSearchLike()
            postCardCell.backCard()
            backCounterFunction()
        }
    }
    
    @objc func edgePanLeftGesture(leftEdgePan: UIScreenEdgePanGestureRecognizer) {
        
        if leftEdgePan.state == .recognized {
            backCardSearchLike()
            postCardCell.backCard()
            backCounterFunction()
        }
    }
    
    // MARK: - CLLocation quest
    private func processResponsers(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            // error funktion noch hinzufügen
//            print("error plz nicht gefunden")
            print(error)
//            print("----1111")
        } else {
//            print("else funktioniert nicht???")
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
//            print("----2222")
            if let location = location {
                let coordinate = location.coordinate
//                print("----3333")
                let coordinateLatitude = coordinate.latitude
                let coordinateLongitude = coordinate.longitude
//                print("company ob Count \(company.count)")
                let coordinaters = CLLocation(latitude: coordinateLatitude, longitude: coordinateLongitude)
//                print("1.0 --->>>>_radiusChossed --> \(_radiusChoosed)")
                for index in company {
//                    print("###### \(index.latitude) &&& \(index.longitude)")
//                    print("----4444")
                    if index.latitude != nil && index.longitude != nil {
                        let latiLongi = CLLocation(latitude: index.latitude!, longitude: index.longitude!)
                        let radiusComp = index.radius!
                        let distance = coordinaters.distance(from: latiLongi) / 1000
//                        print("--->>>>_radiusChossed --> \(_radiusChoosed)")
//                        print("----5555")
                        if distance <= _radiusChoosed {
                            if distance <= radiusComp || radiusComp == 0 && index.uid!.count < 1 {
//                                print("----66666")
                                // hier die daten bzw. userId welche posts davon infrage kommen
    //                            cardSearchTextSecond = index.uid!
    //                            print("printPostText--\(index)")
                                cardSearchTextSecond.append(index.uid!)
//                                print("cardSearchTextSecond \(cardSearchTextSecond)")
//                                print("uid ---- \(index.uid!)")
                                let uniq = Array(Set(cardSearchTextSecond))
    //                            print("uniq ----- \(cardSearchTextSecond.count)")
    //                            print(uniq)
                                cardSearchTextSecond = uniq
//                                print("cardSearchTextSecond \(cardSearchTextSecond)")
                                print("Handwerker ist innerhalb von Radius -> \(distance) ++ \(index.email!) ++ \(index.countryCode!) -> postUid -> \(index.uid!)")
//                                secondfetchCardSearch()
                            } else {
                                print("Du bist zu weit weg f. Handwerker -> \(distance) -- \(index.email!) ++ \(index.countryCode!)")
                                outOfRadiusIndicator += 1
                            }
                        } else {
                            print("Handwerker ist zu weit weg -> \(distance) ++ \(index.email!) ++ \(index.countryCode!) ++ postId \(index)")
                            outOfRadiusIndicator += 1
                        }
                    }
                }
//                print("klappt nicht llllllll")
            }
        }
//        fetchCardSearch()
        secondfetchCardSearch()
//        print("------wann-----")
    }
    
    // MARK: - Navigation Setup
    @objc func unwindToHome() {
        
        if userUidFromShowImage.count != 0 && cardPostsFromShow.count != 0 {
            performSegue(withIdentifier: "SearchPostToShowVC", sender: self)
            
            topStatusHiddenByUnwind()
            cardPostsFromShow.removeAll()
            redButton.removeAll()
            countRedButton = 0
            disconfirmStatusCompany()
            print("uwnind Default__ ACHTUNG löscht FromShow >> unwind to Show VC")
        } else if coreDataArray.count != 0 {
            performSegue(withIdentifier: "unwindUserVC", sender: self)
            topStatusHiddenByUnwind()
            disconfirmStatusCompany()
        } else {
            performSegue(withIdentifier: "unwindToHome", sender: self)
            topStatusHiddenByUnwind()
            disconfirmStatusCompany()
        }
    }
    
    
    
    // MARK: - Action
    
    @IBAction func unwindDefaultALTER(_ sender: UIStoryboardSegue) {
        
        print("uwnind Default__ Start")
        
        chevronLeftSetup()
        if coreDataArray.count != 0 {
            if userUidFromShowImage.count != 0 {
                counterAgainst = 0
                postCardCell.visibleShowCards = 3
                userUidFromShowImage = ""
                fetchLikePosts()
                textOfSearchLabel.text = "Deine Likes"
                print("uwnind Default__2.0 über meine Likes \(textOfSearchLabel)")
            }
            self.disconfirmStatusCompany()
            print("uwnind Default__ über meine Likes \(textOfSearchLabel)")
        } else if cardPostText.count != 0 {
            print("+++_ userUID_____\(userUidFromShowImage.count)")
            if userUidFromShowImage.count != 0 {
                counterAgainst = 0
                postCardCell.visibleShowCards = 3
                userUidFromShowImage = ""
                cardPostSearch()
                self.textOfSearchLabel.text = self.myTextSearch
                print("uwnind Default__2.o über den Karten klick \(textOfSearchLabel)")
            }
            self.disconfirmStatusCompany()
            print("uwnind Default__ über den Karten klick \(textOfSearchLabel)")
        } else if cardSearchText.count != 0 {
            if userUidFromShowImage.count != 0 {
                counterAgainst = 0
                postCardCell.visibleShowCards = 3
                userUidFromShowImage = ""
//                fetchCardSearch()
                secondfetchCardSearch()
                self.textOfSearchLabel.text = self.myTextSearch
                print("uwnind Default__2.o über die Texteingabe \(textOfSearchLabel)")
            }
            self.disconfirmStatusCompany()
            print("uwnind Default__ über die Texteingabe \(textOfSearchLabel)")
        }
        print("uwnind Default__ Ende")
    }
    
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//        
//        print("unwindSegue > TEST")
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
//            dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/2 , y: 0)
//
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
//                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//                
//            } completion: { (finished) in
//                src.navigationController?.present(dst, animated: false, completion: nil)
//            }
//
//        }
//    }
        
            
    @IBAction func unwindFromShowImage(_ unwindImageShowVC: UIStoryboardSegue) {
        print("likeCheck _ unwind")
        if unwindImageShowVC.source is ShowViewController {
            if let senderVC = unwindImageShowVC.source as? ShowViewController {
                chevronDownSetup()
                userUidFromShowImage = senderVC.userUidForUnwindSegue
                fetchCurrenUser()
                countRedButton = 0
                counterAgainst = 0
                postCardCell.visibleShowCards = 3
                redButton.removeAll()
                fetchUserPost()
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        print("likeCheck ____postText \(postTextForMail)")
        if noInternetView.isHidden == true {
            shareAPost()
            UIView.animate(withDuration: 0.1) {
                self.view.alpha = 0.75
                self.view.isUserInteractionEnabled = false
            }
        }
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        backCardSearchLike()
        postCardCell.backCard()
        backCounterFunction()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        if likeButton.backgroundColor != redColor && countRedButton != cardPosts.count {
            isLikeButton()
            saveData()
            loadCoreData()
            
        } else if likeButton.backgroundColor != redColor && countRedButton != cardSearch.count {
            isLikeButton()
            saveData()
            loadCoreData()
        } else if likeButton.backgroundColor == redColor {
            deleteSwipeCard()
        }
    }
    
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        print("coordinate_Mail \(mail)")
        print("coordinate_Mail Text \(postTextForMail)")
        if MFMailComposeViewController.canSendMail() {
            self.successMail()
        } else {
            self.mailError()
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        print("coordinate_loc \(longitude) && \(latitude)")
        print("coordinate_loc Text \(uidForToolButtons)")
        print("coordinate_loc Name Comb \(testCompanyName)")
        print("coordinate_loc phones \(phone) && \(mobile)")
        print("coordinate_loc mail \(mail)")
        if longitude != 0 && latitude != 0 {
            guard let urlAppleMaps = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)") else { return }
            guard let urlGoogleMaps = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&zoom=14&views=traffic") else { return }
            guard let webGoogleMaps = URL(string: "https://www.google.co.in/maps/dir/?q=\(latitude),\(longitude)&zoom=14&views=traffic") else { return }
            guard let openGoogleMaps = URL(string: "comgooglemaps://") else { return }

            print("google___URL___\(urlGoogleMaps)")
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
        } else {
            let error = UIAlertController(title: "Hinweis!", message: "Adresse nicht hinterlegt", preferredStyle: .alert)
            error.addAction(UIAlertAction(title: "Zurück", style: .cancel, handler: nil))
            present(error, animated: true, completion: nil)

        }
        
        
    }
    
    
    @IBAction func phoneButtonTapped(_ sender: UIButton) {
        print("coordinate_Phone \(phone)")
        print("coordinate_Mobile \(mobile)")
        
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
    
    
}

extension SearchPostViewController {
    
    func numberOfCardToShow() -> Int {
        if cardSearchText.count != 0 && userUidFromShowImage.count == 0 {
            counter = cardSearch.count
            postCount.text = "\(cardSearch.count)"
            
            if totalCounter != cardSearch.count {
                againstCounter.text = "\(cardSearch.count)"
                if counterAgainst == totalCounter {
                    disconfirmBackButton()
                }
            }
            cardPostsFromShow.removeAll()
            cardPosts.removeAll()
            totalCounter = cardSearch.count
        } else if cardPostText.count != 0 && userUidFromShowImage.count == 0{
//            print("counterPostSearch \(cardPostText)")
            counter = cardPosts.count
            postCount.text = "\(cardPosts.count)"
            
            if totalCounter != cardPosts.count {
                againstCounter.text = "\(cardPosts.count)"
                if counterAgainst == totalCounter {
                    disconfirmBackButton()
                }
            }
            cardPostsFromShow.removeAll()
            cardSearch.removeAll()
            totalCounter = cardPosts.count
        } else if shareIDFromFirebase.count != 0 && cardPostText.count == 0 && userUidFromShowImage.count == 0{
            counter = cardPosts.count
            postCount.text = "\(cardPosts.count)"
            
            if totalCounter != cardPosts.count {
                againstCounter.text = "\(cardPosts.count)"
                if counterAgainst == totalCounter {
                    disconfirmBackButton()
                }
            }
            cardPostsFromShow.removeAll()
            cardSearch.removeAll()
            totalCounter = cardPosts.count
        } else if userUidFromShowImage.count != 0 && cardPostsFromShow.count != 0 {
            counter = cardPostsFromShow.count
            postCount.text = "\(cardPostsFromShow.count)"
            
            if totalCounter != cardPostsFromShow.count {
                againstCounter.text = "\(cardPostsFromShow.count)"
                if counterAgainst == totalCounter {
                    disconfirmBackButton()
                }
            }
            
            cardSearch.removeAll()
            cardPosts.removeAll()
            totalCounter = cardPostsFromShow.count
            
        }
        
        print("___Counter \(counter)")
        return counter
    }
    
    func card(forItemAtIndex index: Int) -> PostSwipeCard {
        let card = PostSwipeCard()
        if cardPostText.count != 0 && userUidFromShowImage.count == 0{
            card.post = cardPosts[index]
            cardSearch.removeAll()
            firstCardSearchLike()
            print("visible Cards __ CardPost")
        } else if cardSearchText.count != 0 && userUidFromShowImage.count == 0 {
            card.post = cardSearch[index]
            cardPosts.removeAll()
            firstCardSearchLike()
            print("visible Cards __cardSearch")
        } else if shareIDFromFirebase.count != 0 && cardPostText.count == 0 {
            card.post = cardPosts[index]
            cardSearch.removeAll()
            firstCardSearchLike()
            print("visible Cards __ shareFunc")
        } else if userUidFromShowImage.count != 0 && cardPostsFromShow.count != 0 {
            card.post = cardPostsFromShow[index]
            card.removeTapGesture()
//            cardSearch.removeAll()
//            cardPosts.removeAll()
            firstCardSearchLike()
            print("visible Cards __ Company Homepage")
            
        }
        print("geht gar nichts oder")
        card.delegateHandle = self
        card.delegatePostId = self
        card.likeUnlikeDelegate = self
        
        constraintCardCheck()
        
        return card
    }
    
    func emptyView() -> UIView? {
//        print("geht das was bei nil???")
        return nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchPostToShowVC" {
            let showCompanyVC = segue.destination as! ShowViewController
            showCompanyVC._userUid = self.swipedCard
            showCompanyVC._postText = self.swipedCardText
            print("visible Cards _-X___funtzt 2.o")
//            print("swipedCard -> \(swipedCard)")
//            print("swipeCardText -> \(swipedCardText)")
//            print("swipeCard ---<<<\(swipedCard.count)")
//            print("das funktioniert schon wieder oder wie \(swipedCardId)")
        }
    }
}

extension SearchPostViewController: PostSwipeDelegate {
    
    func tappedPostCard(userUid: String, postText: String, postId: String) {
        self.swipedCard = userUid
        self.swipedCardText = postText
        self.swipedCardId = postId
        performSegue(withIdentifier: "SearchPostToShowVC", sender: self)
        self.topStatusHiddenByUnwind()
//        print("test für ToolBar __bySwipe \(userUid) &&& check by Text \(postText)")
//        print("das funktioniert oder wie \(swipedCardId)")
    }
}

// MARK - receiver PostId from Core Data
extension SearchPostViewController: PostSwipeId {
    func loadPostId(postId: String, coreId: String) {
//        print("test für ToolBar __bySwipe -> \(postId)")
        
//        self.swipedCardId = postId
//        self.coreId = coreId

//        print("ist das die ID \(swipedCardId)")
//        print("ist das die ID \(coreId)")
    }
}

// MARK: - like and unlike function -> StackContainerPost -> evt. nicht benötigt
extension SearchPostViewController: likeAndUnlikeDelegate {
    func likeAndUnlike() {
//        likeButton.backgroundColor = UIColor(red: 227/255, green: 205/255, blue: 27/255, alpha: 1.0)
//        print("buttonLike row: 381 = yellow")
//        buttonLikeCheck()
    }
}

// MARK: - like and unlike function -> postSwipeCard
extension SearchPostViewController: buttonLikeDelagate {
    func buttonLike() {
//        likeButton.backgroundColor = .red
//        print("buttonLike row: 388 = red")
    }
}

extension SearchPostViewController: comparisonID {
    func compareID() {
        print("visible Cards _counterAgianst  ERSTER---nach jeden swipe \(counterAgainst)????")
        cardSearchLike()
        print("visible Cards _counterAgianst  ZWEITER---nach jeden swipe \(counterAgainst)????")
        let secondCounter = counterAgainst
        if secondCounter != 0 {
            counterAgainst -= 1
        } else {
            counterAgainst = totalCounter - 1
        }
        againstCounter.text = "\(counterAgainst)"
        
        
        print("visible Cards _counterAgianst  ---nach jeden swipe \(counterAgainst)????")
        if counterAgainst == 0 {
            confirmBackButton()
            disconfirmPhoneButton()
            disconfirmLocationButton()
            disconfirmShareButton()
            disconfirmMailButton()
            disconfirmLikeButton()
        }
        
        if counterAgainst == totalCounter {
            disconfirmBackButton()
            confirmToolButtons()
        } else if counterAgainst != 0 {
            confirmBackButton()
            confirmToolButtons()
        }
        
    }
}

extension String {
    func replaces(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replaces(string: " ", replacement: "")
    }
}

//extension SearchPostViewController: UIActivityItemSource {
//    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
//        return UIImage()
//    }
//
//    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//        return firebaseLink?.absoluteURL
//    }
//
//    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
//        let metadate = LPLinkMetadata()
//        metadate.title = "Check den neuen Post aus 👉🏻\(self.shareText) auf Wopho1"
//        metadate.originalURL = firebaseLink
//        metadate.url = firebaseLink
//        metadate.imageProvider = NSItemProvider.init(contentsOf: firebaseLink)
//        metadate.iconProvider = NSItemProvider.init(contentsOf: firebaseLink)
//
//        return metadate
//    }
//}
