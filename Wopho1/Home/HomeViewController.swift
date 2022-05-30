//
//  HomeViewController.swift
//  PiCCO
//
//  Created by Sebastian Schmitt on 17.06.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import Network
import CoreLocation
import CoreData
import FirebaseDatabase
import MessageUI



protocol ZeroTextDelegate {
    func zeroLabelText(zero: String)
}

class HomeViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchControllerDelegate, CLLocationManagerDelegate {
    
    // class hinzufügen falls UIViewController nicht klappt -> UITableViewController
    
    // MARK: - Outlet
    @IBOutlet weak var radiusTwoFiftyButton: UIButton!
    @IBOutlet weak var radiusFifButton: UIButton!
    @IBOutlet weak var radiusOneButton: UIButton!
    @IBOutlet weak var radiusTwoButton: UIButton!
    @IBOutlet weak var mainCollectionViewCell: UICollectionView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchSecondButton: UIButton!
//    @IBOutlet weak var underlineSearchButton: UIView!
    @IBOutlet weak var resultTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewNoteZipCode: UIView!
    @IBOutlet weak var labelZipCode: UILabel!
    
    @IBOutlet weak var responViewOverZipButton: UIView!
    
    
    @IBOutlet weak var radiusTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var currentTopContraint: NSLayoutConstraint!
    @IBOutlet var zipCodeTopConstraint: UIView!
    @IBOutlet weak var zipTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var currentViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var currentPointView: UIView!
    @IBOutlet weak var zipCodePointView: UIView!
    @IBOutlet weak var radiusPointView: UIView!
    
    // resultTableViewHeight
    @IBOutlet weak var notInternetLabel: UILabel!
    @IBOutlet weak var notInternetImage: UIImageView!
    
    @IBOutlet weak var testTextFeld: UITextField! {
        didSet {
            rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
            testTextFeld.clearButtonRect(forBounds: rectForClearButton)
        }
    }
    
    
    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var radiusDataTextField: UITextField!
    @IBOutlet weak var searchDataViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var searchBarSec: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    // MARK: - layout for which iphone
    @IBOutlet weak var topConstraintExploreLabel: NSLayoutConstraint!
    
    
    // MARK: - var / let
    
    // TEST
    var delegatecounterTestVC: TestCollectionViewCell!
    let viewBackgroundColor = UIColor(red: 0/61, green: 0/61, blue: 0/61, alpha: 0.61)
    let buttonColor = UIColor(displayP3Red: 0, green: 139, blue: 139, alpha: 0.39)
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
//    var users = [UserModel]()
//    var filterUsers = [UserModel]()
    
    // tableView automatische höhe testen
    var maxTableViewHeigt: CGFloat = UIScreen.main.bounds.size.height
    //
    
    // neues var für neues Karten Layout
    var company = [UserModel]()
    var postIdForDistance = [PostModel]()
//    var segueFromCompanyId = [UserModel]()
    var segueFromCompanyId: [String] = []
    lazy var gecoder = CLGeocoder()
    let locationManager = CLLocationManager()
    var toCompareRadius: [String] = []
    var toCompareTheId: [String] = []
//    var postedByGeocoder = [PostModel]()
    
    // ENDE
    var isLoading = false
    
    var search = ""
    var searchRef = "_"
    var _zipCode = ""
    var _zipCodeRef = "_"
    var _postText = ""
    var _postId = ""
    var radiusChoosed = 0.0
    var radiusRef = 0.1
    var radiusText = ""
    
    var textOfMySearch = ""
    
    var _linkFromFirebase = ""
    
    var homeTimestamp: Double = 0.0
    
    var cellCounter = 0
    var tableViewHeigh: CGFloat = 175.0
    var zeroCell: [String] = ["blöd für dich gelaufen"]
    var zeroText = ""
    
    var testerWieOftSystemLaueft = 0
    
    // tester für suchzelle
    var testSuche: [String] = []
    var testerSucheZwei: [String] = []
    
    var posts = [PostModel]()
    
    var posted = [PostModel]()
    var filterPosts = [PostModel]()
    
    var tappedPost = [PostModel]()
//    var searchController: UISearchController!
//    private var resultTableController: ResultTableViewController!
//    let searchController = UISearchController(searchResultsController: nil)
    
    //let tableViewCellId = "cellID"
    
//    var monitor: NWPathMonitor = NWPathMonitor()
//    let moni = NWPathMonitor(requiredInterfaceType: .wifi)
//    var queue = DispatchQueue(label: "Monitor")
    
    let refresh = UIRefreshControl()
    var activityIndi: UIActivityIndicatorView?
    
    var rectForClearButton = CGRect.zero
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
//    @objc private func refreshData(_ sender: AnyObject) {
//        activityIndi?.isHidden = false
//        activityIndi?.startAnimating()
//        refreshTheData()
////        loadPosts()
//    }
//
//    private func refreshTheData() {
//        PostApi.shared.fetchALimitOfPosts { (post) in
//            self.posts.append(post)
//            self.mainCollectionViewCell.reloadData()
////            self.activityIndicatorView.stopAnimating()
////            self.activityIndicatorView.isHidden = true
//
//        }
//
//        self.activityIndi?.stopAnimating()
////        self.refresh.endRefreshing()
////        self.activityIndicatorView.stopAnimating()
//    }
//
//    @objc func refresherTest() {
//        activityIndi?.startAnimating()
//        print("start den indi")
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentInset
//
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationItem.setHidesBackButton(false, animated: false)
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//        self.modalPresentationStyle = .fullScreen
        self.hidesBottomBarWhenPushed = false
        rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
        testTextFeld.clearButtonRect(forBounds: rectForClearButton)
        
        if UIDevice.current.hasNotch {
            print("ich hab- eine Notch")
        } else {
            print("ich hab- keine Notch")
            topConstraintExploreLabel.constant = 80
        }
        
//        activityIndi = UIActivityIndicatorView(frame: refresh.bounds)
//        activityIndi?.backgroundColor = refresh.backgroundColor
//        activityIndi?.translatesAutoresizingMaskIntoConstraints = false
//        activityIndi?.color = .blue
//
//        refresh.addSubview(activityIndi!)
//
//        let testBottom = NSLayoutConstraint(item: activityIndi!, attribute: .bottom, relatedBy: .equal, toItem: refresh, attribute: .bottom, multiplier: 1, constant: 0)
//        refresh.addConstraint(testBottom)
//
//        refresh.backgroundColor = .clear
////        refresh.addTarget(self, action: #selector(refresherTest), for: .valueChanged)
//
//        mainCollectionViewCell.addSubview(refresh)
        
        
        
        checkInternet()
        
        // MARK: - der CollectionView refresh test
//        if #available(iOS 10.0, *) {
//            mainCollectionViewCell.refreshControl = refresh
//        } else {
//            mainCollectionViewCell.addSubview(refresh)
//        }
        
        
        
//        refresh.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
//        refresh.tintColor = .red
//        refresh.attributedTitle = NSAttributedString(string: "dertester", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
////        refresh.hor
//        mainCollectionViewCell.alwaysBounceHorizontal = true
//        mainCollectionViewCell.refreshControl = refresh
//
////        mainCollectionViewCell.insertSubview(refresh, at: 0)
//        mainCollectionViewCell.alwaysBounceHorizontal = true
//        refresh.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint(item: refresh, attribute: .centerX, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: refresh, attribute: .centerY, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
//        print("ABABABABABABAB", filterPosts.count)
        
        
        //TEST
//        let nib = UINib(nibName: "TableCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: tableViewCellId)
        // zweiter akt 01.02.20
//        resultTableController = self.storyboard?.instantiateViewController(withIdentifier: "ResultTableViewController") as? ResultTableViewController
//        resultTableController.tableView.delegate = self
        searchBarSec.delegate = self
        testTextFeld.delegate = self
        zipTextField.delegate = self
        radiusDataTextField.delegate = self
        
        
        resultTableView.dataSource = self
        resultTableView.tableFooterView = UIView(frame: .zero)
        resultTableView.rowHeight = UITableView.automaticDimension
        resultTableView.estimatedRowHeight = UITableView.automaticDimension
        
//        searchController = UISearchController(searchResultsController: resultTableController)
//        searchController.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.autocapitalizationType = .none
////        searchController.searchBar.delegate = self
//
//        searchController.hidesNavigationBarDuringPresentation = false
////        searchController.dimsBackgroundDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = false
        
//        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true


        definesPresentationContext = true
        
        // TEST Area
        testToucheFive()
        // ENDE
        
        activityIndicatorView.stopAnimating()
//        configRefreshControl()
        mainCollectionViewCell.delegate = self
        mainCollectionViewCell.dataSource = self
        mainCollectionViewCell.alwaysBounceHorizontal = true
//        mainCollectionViewCell.showsHorizontalScrollIndicator = true
//        mainCollectionViewCell.alwaysBounceHorizontal = true
        
        
//        mainCollectionViewCell.alwaysBounceHorizontal = true
//        searchBarTextField.delegate = self
        countryCodeTextField.delegate = self
        
        tableViewSetup()
        
//        setupSearchBar()
        
        // evtl. erst ausführen wenn SearchBar geklickt wurde -> test 22.04.20 bei func´s in func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
//        filteredSearchBarPost()
//        searchBarPost()
        // Ende
        
//        searchPost()
        setupView()
        loadPosts()
        addTargetToRadiusButton()
        
        self.navigationItem.titleView = navigationTitle(text: "App_Name")
        
//        searchController.searchBar.barTintColor = .purple
//
//        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
//            if let backgroundview = textField.subviews.first {
//                backgroundview.backgroundColor = UIColor.init(white: 1, alpha: 1)
//            }
//        }
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        print("Image Collection -------§§§ -- \(mainCollectionViewCell.frame.height)")
        testTextFeld.addTarget(self, action: #selector(touchInTestTextField), for: .touchDown)
        zipTextField.addTarget(self, action: #selector(touchDownZipField), for: .touchDown)
        radiusDataTextField.addTarget(self, action: #selector(touchDownRadiusField), for: .touchDown)
        
        zipTextField.addTarget(self, action: #selector(endOfTouchZipTextField), for: .editingDidEnd)
        radiusDataTextField.addTarget(self, action: #selector(endOfTouchRadiusDataTextField), for: .editingDidEnd)
        
        
//        gecoderSetup()
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - TextField Setup
    
    @objc func touchDownZipField() {
        print("resultHidden -> -> -> 1")
        resultTableView.isHidden = true
    }
    
    @objc func touchDownRadiusField() {
        print("resultHidden -> -> -> 2")
        resultTableView.isHidden = true
    }
    
    @objc func endOfTouchZipTextField() {
        //print("ich bin raus -> ZipCode")
        if _zipCode != _zipCodeRef {
            
            company.removeAll()
            posted.removeAll()
            filterPosts.removeAll()
//            _zipCodeRef = _zipCode
            print("ich bin raus -> ZipCode")
        }
    }
    
    @objc func endOfTouchRadiusDataTextField() {
        //print("ich bin raus -> Radius")
        if radiusChoosed != radiusRef {
            company.removeAll()
            posted.removeAll()
            filterPosts.removeAll()
//            radiusRef = radiusChoosed
            print("ich bin raus -> Radius")
        }
    }
    
    @objc func touchInTestTextField() {
        print("ich bin der Download part 00er_______")
        print("wieviel Filtered count -> \(filterPosts.count) && posted count \(posted.count)")
        
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveLinear) {
            print("ich bin der -> erste 1")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("resultHidden -> false-> -> 1 ")
                self.resultTableView.isHidden = false
                print("ich bin der resulteTablieView hidden false -> 1")
                print("4er die nummer -> 1")
                self.searchBarSec.text = self.testTextFeld.text
                self.searchRef = self.testTextFeld.text!
                self.testTextFeld.isEqual(self.searchBarSec)
                self.searchBar(self.searchBarSec, textDidChange: self.testTextFeld.text!)
                
            }
        } completion: { (end) in
            print("ich bin der -> zweiter 2")
            if self._zipCode.count == 5 && self.radiusChoosed != 0.0 {
                if self.radiusChoosed != self.radiusRef || self._zipCode != self._zipCodeRef {
                    print("ich bin der Download part 1")
                    self.downlaodUserData()
                    self.radiusRef = self.radiusChoosed
                    self._zipCodeRef = self._zipCode
                }
            } else {
                self.downlaodUserData()
                self.radiusRef = self.radiusChoosed
                self._zipCodeRef = self._zipCode
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardHigh = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
//        UIView.animate(withDuration: keyboardDuration) {
//            let highOfKeyboard: CGFloat
//            highOfKeyboard = keyboardHigh.cgRectValue.height
//            let tabrr = self.tabBarController?.tabBar.frame.height
//            self.searchDataViewConstraint.constant = -291 + tabrr!
//            if self.zipTextField.isFirstResponder == true || self.radiusDataTextField.isFirstResponder == true {
//                print("high of The keyboard 1st >>>> constan \(self.searchDataView.frame.height)")
//
//                print("high of The keyboard \(highOfKeyboard) && constan \(self.searchDataViewConstraint.constant) && segment high && view high \(tabrr)")
////                self.searchDataView.translatesAutoresizingMaskIntoConstraints = false
////                self.searchDataView.layoutIfNeeded()
//            }
//        }
        if self.zipTextField.isFirstResponder == true || self.radiusDataTextField.isFirstResponder == true {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut) {
                let highOfKeyboard: CGFloat
                highOfKeyboard = keyboardHigh.cgRectValue.height
                let resultKeyboardHigh = highOfKeyboard - highOfKeyboard * 2
                let tabrr = self.tabBarController?.tabBar.frame.height
                self.searchDataViewConstraint.constant = resultKeyboardHigh + tabrr!
                self.view.layoutIfNeeded()
            } completion: { _ in
                
            }
        }
        

        
//        UIView.animate(withDuration: keyboardDuration, delay: 10.2, options: UIView.AnimationOptions(rawValue: keyboardCurve)) {
//            self.view.layoutIfNeeded()
//
//
//        } completion: { _ in
//            let highOfKeyboard: CGFloat
//            highOfKeyboard = keyboardHigh.cgRectValue.height
//            let tabrr = self.tabBarController?.tabBar.frame.height
//            self.searchDataViewConstraint.constant = -291 + tabrr!
//        }

        
        

        
//        UIView.animate(withDuration: TimeInterval(truncating: keyboardDuration), delay: 0.0, options: UIView.AnimationOptions(rawValue: UInt(truncating: keyboardCurve))) {
//            let highOfKeyboard: CGFloat
//            highOfKeyboard = keyboardHigh.cgRectValue.height
//            let tabrr = self.tabBarController?.tabBar.frame.height
//            if self.zipTextField.isFirstResponder == true || self.radiusDataTextField.isFirstResponder == true {
//                print("high of The keyboard 1st >>>> constan \(self.searchDataView.frame.height)")
//                self.searchDataViewConstraint.constant = -291 + tabrr!
//                print("high of The keyboard \(highOfKeyboard) && constan \(self.searchDataViewConstraint.constant) && segment high && view high \(tabrr)")
////                self.searchDataView.translatesAutoresizingMaskIntoConstraints = false
////                self.searchDataView.layoutIfNeeded()
//            }
//        } completion: { _ in
//        }

    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 1.1) {
            self.searchDataViewConstraint.constant = 0
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        monitor.pathUpdateHandler = {
//            path in
//            if path.status == .satisfied {
//                DispatchQueue.main.async {
//                    print("____Internet --- geht")
//                }
//
//            } else {
//                DispatchQueue.main.async {
//                    print("____Internet --- keine Funktion")
//                }
//
//            }
//
//            self.monitor.start(queue: self.queue)
//        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.resultTableView.layoutSubviews()
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        super.viewWillLayoutSubviews()
        mainCollectionViewCell.collectionViewLayout.invalidateLayout()
        
//        self.resultTableViewHeight?.constant = self.resultTableView.contentSize.height
        
//        print("cellCounter in Switch ----- \(cellCounter)")
        
//        switch cellCounter {
//        case 3:
//            tableViewHeigh -= 13.5
//        case 2:
//            tableViewHeigh -= 28.5
//        case 1:
//            tableViewHeigh -= 43.5
//        default:
//            tableViewHeigh = 0
//            print("___________default")
//        }
//
//        self.resultTableViewHeight.constant -= tableViewHeigh
        
//        DispatchQueue.main.async {
//            self.resultTableViewHeight.constant = self.resultTableView.contentSize.height
//            self.view.layoutIfNeeded()
//        }
    }
    
    
    func testToucheFive() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleZipLabel))
        labelZipCode.addGestureRecognizer(tapGesture)
        labelZipCode.isUserInteractionEnabled = true
        
        let tapGestureView = UITapGestureRecognizer(target: self, action: #selector(handleResponView))
        responViewOverZipButton.addGestureRecognizer(tapGestureView)
        responViewOverZipButton.isUserInteractionEnabled = true
        
    }
    
    @objc func handleZipLabel() {
        print("touches began at Label is YEEEEEEEES-------")
        if countryCodeTextField.isHidden == true {
            UIView.animate(withDuration: 0.9) {
                self.countryCodeTextField.isHidden = false
                self.viewNoteZipCode.isHidden = true
            }
        }
    }
    
    @objc func handleResponView() {
        print("YEEEEES ---- respon View funktoniert")
        if radiusTwoFiftyButton.backgroundColor == UIColor(white: 1.0, alpha: 0.1) {
            UIView.animate(withDuration: 0.9) {
                self.countryCodeTextField.isHidden = true
//                self.viewNoteZipCode.isHidden = false
            }
        }
    }
    
    
    // MARK: - Refresh Control
//    func configRefreshControl() {
//
//        mainCollectionViewCell.refreshControl = UIRefreshControl()
//        mainCollectionViewCell.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
//
//    }
//
//
//    @objc func handleRefreshControl() {
//        mainCollectionViewCell.refreshControl?.attributedTitle = NSAttributedString(string: "reload data", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//
//        DispatchQueue.main.async {
//            self.mainCollectionViewCell.refreshControl?.endRefreshing()
//        }
//    }
    
    // MARK: - Table View Dynamic heigh
    
    // Delegate fünktioniert nicht des var didSet
    var delegateZeroText: ZeroTextDelegate?
    
    @objc func handleZeroText() {
        let text = zeroText
        print("HomeVC zeroText --- 111 \(text)")
        delegateZeroText?.zeroLabelText(zero: text)
    }
    
    func dynamicTableViewHigh() {
//        print("cellCount LINE 155 --- \(cellCounter)")
        switch cellCounter {
        case 3:
            resultTableViewHeight.constant = 131.25
        case 2:
            resultTableViewHeight.constant = 87.5
        case 1:
            resultTableViewHeight.constant = 43.75
        case 0:
            resultTableViewHeight.constant = 0.0
            zeroText = "blöd für dich gelaufen"
        default:
            resultTableViewHeight.constant = 175.0
        }
    }
    
    // MARK: - Search Bar
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchController = UISearchController(searchResultsController: resultTableController)
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.autocapitalizationType = .none
//        searchController.searchBar.delegate = self
//        searchController.searchBar.placeholder = "TEST1123344"
//    }
    
//    func setupSearchBar() {
//            searchBarTextField.tintColor = UIColor.white
//            searchBarTextField.searchTextField.leftView?.tintColor = .white
//            searchBarTextField.searchTextField.textColor = .white
//            searchBarTextField.searchTextField.attributedPlaceholder = NSAttributedString(string: "suche dein bild handwerk", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green])
//            searchBarTextField.searchTextField.font = UIFont.boldSystemFont(ofSize: 18)
//        }
    
//    func searchPost() {
//        guard let searchText = searchBarTextField.text else { return }
//        //self.posts.removeAll()
//        self.searchs.removeAll()
//
//        PostApi.shared.queryPost(withText: searchText) { (post) in
//            //self.posts.append(post)
//            self.searchs.append(post)
//
//        }
//    }
    
//    func searchBarPost() {
//        print("_>_>_>_>_>_>_>_SEARCHBARTEST")
//        guard let searchText1 = searchController.searchBar.text else { return }
//        self.searchs.removeAll()
//
//        PostApi.shared.queryPost(withText: searchText1) { (post) in
//            self.searchs.append(post)
//            print("->_>_>_>_>_>_>", self.searchs.count)
//            print("2-2-2-2-2-2-2-", post.postText)
//        }
//    }
    
//    func searchBarPost() {
//        PostApi.shared.observePosts { (post) in
//            self.searchs.append(post)
//        }
//    }
    
//    func searchBarPost() {
//        guard let searchText = searchController.searchBar.text else { return }
//        UserApi.shared.queryUser(withText: searchText) { (user) in
//            self.users.append(user)
////            self.resultTableController.tableView.reloadData()
//            self.resultTableView.reloadData()
//        }
//    }
    
    // Print Befehl wieder verwenden evtl. werden alle Daten schon vorher geladen vor Suchanfrage
    func searchBarPost() {
        print("ich bin an der reihe -> 1")
        if _postText == "kann gelöscht werden -> wurde von != auf == geändert" {
            PostApi.shared.queryPost(withText: _postText) { (textOfPost) in
                self.filterPosts.append(textOfPost)
                self.resultTableView.reloadData()
                self.performSegue(withIdentifier: "showTheResult", sender: nil)
                print("wirst gelöscht_Wichtig 1 counter => posted \(self.posted.count) && filter \(self.filterPosts.count)")
            }
            
        } else if let searchText = searchBarSec.text {
            if searchText != searchRef {
                PostApi.shared.queryPost(withText: searchText) { (post) in
                    self.filterPosts.append(post)
                    self.searchRef = searchText
                    print("wirst gelöscht_Wichtig 2 counter => posted \(self.posted.count) && filter \(self.filterPosts.count)")
                    self.resultTableView.reloadData()
                }
            }
        }
    }
    
    func filteredSearchBarPost() {
        print("ich bin an der reihe -> 2")
        print("filtered __DERECHTESTARTER________ \(searchBarSec.text)")
        print("textField Änderung Part __ 1 -> XXXX && searchBarSec- \(searchBarSec.text)")
        searchBarSec.text = ""
        
        guard let searchText = searchBarSec.text else { return }
        PostApi.shared.queryAllPost(withText: searchText) { (post) in
            print("filtered __1 -> \(self._zipCode.count) && radius \(self.radiusChoosed)")
            if self._zipCode.count == 5 && self.radiusChoosed != 0.0 {
//                print(" zip-> leck mich _\(self.toCompareRadius.count)")
                for i in self.toCompareRadius {
//                    print("filtered __1 -> CompareRadius \(i) && postUID \(post.uid)")
                    print("wirst gelöscht___ 1 nicht \(self.posted.count) ++++ i.count -> \(i.count)")
                    if i == post.uid {
                        
                        self.posted.append(post)
                        print("filtered __ENDTRUE -> CompareRadius \(i) && postUID \(post.uid)---> count \(self.posted.count)")
                        
                        
                        self.resultTableView.reloadData()
                    }
                }
            } else {
                self.posted.append(post)
                print("filtered __ENDE")
                print("wirst gelöscht___ 2 nicht \(self.posted.count)")
                self.resultTableView.reloadData()
            }
        }
    }
    
    func downlaodUserData() {
        print("ich bin an der reihe -> 3")
        testerWieOftSystemLaueft += 1
        print("wie oft1 -> \(testerWieOftSystemLaueft)")
        UserApi.shared.observeUsers { uid in
            self.company.append(uid)
            self.gecoderSetup()
//            print("ich bin der Download part ENDE \(self.company.count)")
        }
    }
    
    func gecoderSetup() {
        print("ich bin an der reihe -> 4")
        print("geb den Standort frei Start")
        let address = _zipCode
        gecoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponsers(wihtPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponsers(wihtPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print(error)
            print("geb den Standort frei")
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                print("geb den Standort frei 1.o")
            }
            
            if let location = location {
                let coordinate = location.coordinate
                let coordinateLatitude = coordinate.latitude
                let coordinateLongitude = coordinate.longitude
                let coordinaters = CLLocation(latitude: coordinateLatitude, longitude: coordinateLongitude)
                print("geb den Standort frei 2.o")
                
                for i in company {
                    if i.latitude != nil && i.longitude != nil {
                        print("geb den Standort frei 3.o")
                        let latiLongi = CLLocation(latitude: i.latitude!, longitude: i.longitude!)
                        let radiusComp = i.radius!
                        let distance = coordinaters.distance(from: latiLongi) / 1000
                        
                        if distance <= radiusChoosed {
                            if distance <= radiusComp || radiusComp == 0 && i.uid!.count < 1 {
                                print("geb den Standort frei 4.0 id- \(i.uid!) ___ \(distance) && radius \(radiusChoosed)")
//                                self.posted.append(post)
//                                self.resultTableView.reloadData()
                                toCompareRadius.append(i.uid!)
                                print("bist du der doppelte count toCompareRadius 1-> \(toCompareRadius.count)")
//                                print("geb den Standort frei 3.5 \(i.uid!)")
                                
                            }
                        }
                    }
                }
            }
        }
        uidResult()
    }
    
    func uidResult() {
        
        for i in toCompareRadius {
            print("geb den Standort frei ENDE with compare \(i)")
            for postIndex in postIdForDistance {
                if postIndex.uid == i {
                    PostApi.shared.observePost(withPodId: postIndex.id!) { post in
                        
                        print("wirst gelöscht 3 nichtt")
                        
                        self.posted.append(post)
                        print("wirst gelöscht___ 3 nicht \(self.posted.count)")
                        self.resultTableView.reloadData()
                        for postIndex in self.posted {
                            print("geb den Standort frei ENDE \(postIndex.postText) und \(i.count)")
                        }
                
                    }
//                    UserApi.shared.observeUser(uid: i) { id in
//                        segueFromCompanyId = id
//                    }
                    segueFromCompanyId.append(i)
                    print("geb den Standort frei ERFOLGREICH \(i)")
            }
        }
    }
    
//    func filteredSearchBarPost() {
//        guard let searchText = searchController.searchBar.text else { return }
//        PostApi.shared.queryPost(withText: searchText) { (post) in
//            self.posted.append(post)
//            print("---count of posted \(self.posted.count)")
//            self.resultTableView.reloadData()
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else { return }
        print("ich bin an der reihe -> 5")
        print("ich such hier")
        guard let text = searchBarSec.text else { return }
        search = text
        textOfMySearch = text
//        downlaodUserData()
//        if postText != "" {
//            search = postText
//            textOfMySearch = postText
//        } else if let text = searchBarSec.text {
//            search = text
//            textOfMySearch = text
//        }
//        print("search", search)
//        print("was Steht Da Im Text \(countryCodeTextField.text)")
        guard let zipCode = zipTextField.text else { return }
        _zipCode = zipCode
        print("geo underline ZipCode -> -> \(_zipCode)")
        _postId.removeAll()
        _postText.removeAll()
        
//        performSegue(withIdentifier: "ShowPostVC", sender: nil)
        performSegue(withIdentifier: "showTheResult", sender: nil)
        print("resultHidden -> -> -> 4")
        resultTableView.isHidden = true
        searchBar.endEditing(true)
//        print("-------geeeesssssssucht")
        if resultTableViewHeight.constant != 175 {
            resultTableViewHeight.constant = 175.0
        }
        view.endEditing(true)
    }
    
    func tableViewSetup() {
        resultTableView.layer.cornerRadius = 10
        resultTableView.backgroundColor = .darkGray
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filteredSearchBarPost()
//        updateSearchResults(for: searchController)
//        let searchResults = posts
//
//        let whitespaceCharacter = CharacterSet.whitespaces
//        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacter)
//        let searchItem = strippedString.components(separatedBy: " ") as [String]
//
//        let andMatchPredicates: [NSPredicate] = searchItem.map { (searchString) -> T in
//        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("####searchBar-TextDid--END--Editing")
        print("resultHidden -> -> -> 5")
        resultTableView.isHidden = true
        if resultTableViewHeight.constant != 175 {
            resultTableViewHeight.constant = 175.0
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("ich bin an der reihe -> 6")
//        print("####searchBar-TextDidBeginEditing")
//        resultTableView.isHidden = false
//        print("bist du er löscher 7")
        print("wirst gelöscht_Wichtig __ -SEARCHBAR 2__  counter => posted \(posted.count) && filter \(filterPosts.count)")
        if filterPosts.count == 0 && posted.count == 0 {
            searchBarPost()
            print("searchBarPost WO ----> 1 <-")
            print("wirst gelöscht__ START___2")
            filteredSearchBarPost()
            print(" zip-> V1 Download posted")
        }

//        UIView.animate(withDuration: 1.5) {
//            self.resultTableView.isHidden = false
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultTableViewHeight.constant = 175.0
        print("--------bist du der Cancel??????test")
        notEnabeldSSB()
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if filterPosts.count == 0 && posted.count == 0 {
//            searchBarPost()
//            filteredSearchBarPost()
//            print(" zip-> V2 Download posted")
//        }
//        print("bist du er löscher 6")
        
        
        print("ich bin an der reihe -> 7")
        print("wirst gelöscht_Wichtig __ -TEXTFIELD 1__  counter => posted \(posted.count) && filter \(filterPosts.count)")
        if textField.isEqual(testTextFeld) {
            if filterPosts.count == 0 && posted.count == 0 {
                print("ich bin an der reihe -> 7 _____ kommst posted && filterPosts - count ZERO")
                print("wirst gelöscht__ START___1")
                searchBarPost()
                filteredSearchBarPost()
                print("searchBarPost WO ----> 2 <-")
                print("textField Änderung Part __ 1.1 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("ich bin an der reihe -> 8")
        print("bist du er löscher 5")
        print("wirst gelöscht_Wichtig __Spring__  counter => posted \(posted.count) && filter \(filterPosts.count)")
        if testTextFeld.isFirstResponder == true {
            print("resultHidden -> false-> -> 2 ")
            self.resultTableView.isHidden = false
            print("ich bin der resulteTablieView hidden false -> 1")
            print("4er die nummer -> 1")
//            searchBarSec.text = textField.text
//            searchRef = textField.text!
            
            searchBarSec.text = testTextFeld.text
            searchRef = testTextFeld.text!
            
    //        searchBarSec.isEqual(testTextFeld)
            testTextFeld.isEqual(searchBarSec)
//            searchBar(searchBarSec, textDidChange: textField.text!)
            searchBar(searchBarSec, textDidChange: testTextFeld.text!)
            print("bist du der First responder")
            print("textField Änderung Part __ 2 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
        } else if testTextFeld.isTouchInside == true {
            // neu gemacht am 14.11.21
            print("4er die nummer -> 2")
            searchBarSec.text = testTextFeld.text
            searchRef = testTextFeld.text!
//            searchBarSec.text = textField.text
//            searchRef = textField.text!
    //        searchBarSec.isEqual(testTextFeld)
            testTextFeld.isEqual(searchBarSec)
//            searchBar(searchBarSec, textDidChange: textField.text!)
            searchBar(searchBarSec, textDidChange: testTextFeld.text!)
            print("textField Änderung Part __ 3 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
        }
        
        if radiusChoosed != radiusRef || _zipCode != _zipCodeRef {
            print("textField Änderung Part __ 4 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
            if _zipCode.count >= 4 || radiusChoosed == 0.0 {
                print("textField Änderung Part __ 5 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
                if textField.isEqual(testTextFeld) == false {
                    //posted.removeAll()
                    //filterPosts.removeAll()
                    print("was für ein -> GELÖSCHT")
                    print("4er die nummer -> 3")
                    
                    print("wirst gelöscht_ 1")
                    print("textField Änderung Part __ 6 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
                }
            }
        }
        
        if textField.isEqual(zipTextField) {
            _zipCode = textField.text!
            print("4er die nummer -> 5")
            print("textField Änderung Part __ 7 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
            print("second radius -> aka zip \(_zipCode)")
        } else if textField.isEqual(radiusDataTextField) {
            guard let text = textField.text else { return }
            
            guard let textToDouble = Double(text) else { return }
            radiusChoosed = textToDouble
            radiusText = text
            print("4er die nummer -> 6")
            print("second radius -> \(radiusChoosed)")
            print("textField Änderung Part __ 8 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
        } else if textField.isEqual(testTextFeld) {
//            downlaodUserData()
            print("4er die nummer -> 7")
            print("geb den Standort --> Download startet")
            print("textField Änderung Part __ 9 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
        }
        
//        if zipTextField.isFirstResponder == true {
//            _zipCode = textField.text!
//        }
//
//        if radiusDataTextField.isFirstResponder == true {
//            guard let text = textField.text else { return }
//            guard let textToInt = Double(text) else { return }
//            radiusChoosed = textToInt
//        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == zipTextField {
            print("ich bin raus -> CANCEL - ZipCode")
            _zipCode = ""
            posted.removeAll()
            filterPosts.removeAll()
        } else if textField == radiusDataTextField {
            print("ich bin raus -> CANCEL - Radius")
            radiusChoosed = 0.0
            radiusText = ""
            posted.removeAll()
            filterPosts.removeAll()
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("bist du er löscher 2")
        print("ich bin an der reihe -> 9")
        searchBarSearchButtonClicked(searchBarSec)
        rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
        testTextFeld.clearButtonRect(forBounds: rectForClearButton)
        textField.clearButtonRect(forBounds: rectForClearButton)
        textField.clearButtonMode = .always
        print("textField Änderung Part __ 10 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
        print("bist du der mister Eingabe")
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("ich bin an der reihe -> 10")
//        rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
//        testTextFeld.clearButtonRect(forBounds: rectForClearButton)
//        textField.clearButtonRect(forBounds: rectForClearButton)
//        textField.clearButtonMode = .always
//        resultTableViewHeight.constant = 175.0
//        notEnabeldSSB()
//
//        if _zipCode.count == 5 && radiusChoosed != 0.0 {
//            if radiusChoosed != radiusRef || _zipCode != _zipCodeRef {
//                print("ich bin der Download part 1")
//                downlaodUserData()
//                radiusRef = radiusChoosed
//                _zipCodeRef = _zipCode
//            }
//        } else if _zipCode.count >= 4 || radiusChoosed == 0.0 {
//            if textField.isEqual(radiusDataTextField) || textField.isEqual(zipTextField) {
//                posted.removeAll()
//                print("ich bin der Download part 2")
//            }
//        }
        
        
        if _zipCode.count >= 4 || radiusChoosed == 0.0 {
            if textField.isEqual(radiusDataTextField) || textField.isEqual(zipTextField) {
                posted.removeAll()
                print("ich bin an der reihe -> 10 Löschung-----")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("ich bin an der reihe -> 11")
        rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
        testTextFeld.clearButtonRect(forBounds: rectForClearButton)
        textField.clearButtonRect(forBounds: rectForClearButton)
        textField.clearButtonMode = .always
        print("bist du er löscher 3")
        print("resultHidden -> -> -> 7")
        resultTableView.isHidden = true
        if resultTableViewHeight.constant != 175 {
            resultTableViewHeight.constant = 175.0
        }
        
        if _zipCode.count >= 4 || radiusChoosed == 0.0 {
            
            
        }
        print("textField Änderung Part __ 13 -> \(textField.text) && searchBarSec- \(searchBarSec.text)")
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchBar.text = searchText.lowercased()
        
        print("ich bin an der reihe -> 12")
        searchBar.text = searchText
        
        
        if let searchTest = searchBar.text, !searchTest.isEmpty {
            
            filterPosts = posted.filter{ (filter) in
                filter.postText!.localizedCaseInsensitiveContains(searchTest)
            }
            print("wirst gelöscht ENDE by FILTERED \(filterPosts.count)")
        } else {
            filterPosts = posted
        }
        print("counts of PostModel posted -> \(posted.count) && filter -> \(filterPosts.count)")
        resultTableView.reloadData()
        print("wieviel Filtered count <-ENDE-> \(filterPosts.count) ")
//        guard let test = searchBar.text?.isEmpty else { return }
//        print("ich verlasse nicht die func -------")
//        self.searchBarPost()
//        self.filteredSearchBarPost()
        if searchBar.text == "" {
            notEnabeldSSB()
            UIView.animate(withDuration: 1.5) {
                self.resultTableView.isHidden = true
            }
        } else {
            enabledSSB()
            /*UIView.animate(withDuration: 1.5) {
                print("resultHidden -> false-> -> 3 ")
                self.resultTableView.isHidden = false
                print("ich bin der resulteTablieView hidden false -> 2")
            }*/
        }

//        print("+++++++searchBar-textDidChange")
//        if searchBar.text == "" && resultTableViewHeight.constant != 175 {
//            resultTableViewHeight.constant = 175.0
//            print("+++2.0++++searchBar-textDidChange")
//
//        }
    }
    
//    private func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("geht das überhaupt")
//        if searchText.isEmpty {
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//                print("_____gelöscht 3.0")
//            }
//
//        }
//    }
    // MARK: - Incoming Share
    func getLink(postId: String) {
        _linkFromFirebase = postId
        loadLink()
    }
    
    func loadLink() {
        if _linkFromFirebase != "" {
            PostApi.shared.observePost(withPodId: _linkFromFirebase) { post in
                self.tappedPost.insert(post, at: 0)
                self.performSegue(withIdentifier: "showTheResult", sender: nil)
            }
        }
    }
    
    // MARK: - Setup View
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        if let text: String = searchBarTextField.text {
//            DispatchQueue.main.async {
//                self.searchBarTextField.text = text.lowercased()
//            }
//        }
//    }
    
//    func searchBarLowercase(searchBar: UISearchBar, textDidChange searchText: String) {
//        searchBar.text = searchText.lowercased()
//
//    }
    
    func checkInternet() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.yeahConnection()
                }
            } else {
                DispatchQueue.main.async {
                    if self.posts.count == 0 {
                        self.noConnection()
                    }
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func yeahConnection() {
        notInternetLabel.isHidden = true
        notInternetImage.isHidden = true
    }
    
    func noConnection() {
        let notImageOfInternet = UIImage(systemName: "wifi.slash")
        notInternetImage.image = notImageOfInternet
        notInternetImage.tintColor = buttonColor
        notInternetLabel.isHidden = false
        notInternetImage.isHidden = false
        notInternetLabel.lineBreakMode = .byWordWrapping
        notInternetLabel.textAlignment = .center
        notInternetLabel.text = "Keine Internetverbindung! \nBitte prüfe dein Netzwerk"
    }
    
    
    func constraintCheck() {
        let collectionHigh = mainCollectionViewCell.frame.height
        
        if collectionHigh <= 354.6666666666667 {
//            radiusTopConstraint.constant = 10
//            currentTopContraint.constant = 5
//            currentViewConstraint.constant = 122.67
//            zipTopConstraint.constant = 10
            
            print("current Collection View HIgh fuuuuuunnnzzzrt")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
        testTextFeld.clearButtonRect(forBounds: rectForClearButton)
        textField.clearButtonRect(forBounds: rectForClearButton)
        textField.clearButtonMode = .always
        var maxLength: Int
        if textField.isEqual(zipTextField) {
            maxLength = 5
        } else if textField.isEqual(radiusDataTextField) {
            maxLength = 3
        } else {
            maxLength = 250
        }
//        print("bist du er löscher 4 -> counter \(maxLength)")
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    // MARK: - Setup View
    
    func setupView() {
        testTextFeld.clearButtonMode = .always
        let test = CGRect(x: 50, y: 0, width: 10, height: 10)
        testTextFeld.clearButtonRect(forBounds: test)
        testTextFeld.returnKeyType = .search
        testTextFeld.tintColor = .black
        testTextFeld.textColor = UIColor.white
        testTextFeld.backgroundColor = darkgrayButtonColor
        testTextFeld.layer.cornerRadius = testTextFeld.frame.size.height/2
        testTextFeld.clipsToBounds = true
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let searchFieldFake = NSAttributedString(string: "Suche deinen Dienstleister", attributes: attribute)
        testTextFeld.attributedPlaceholder = searchFieldFake
        testTextFeld.leftViewMode = UITextField.ViewMode.always
        testTextFeld.font = UIFont.boldSystemFont(ofSize: 15)
        testTextFeld.layer.borderColor = testTextFeld.tintColor.cgColor
        testTextFeld.tintColor = .black
        testTextFeld.layer.borderWidth = 1.5
        rectForClearButton = CGRect(x: 50, y: 50, width: 20, height: 20)
        testTextFeld.clearButtonRect(forBounds: rectForClearButton)
        testTextFeld.clearButtonMode = .always
        let textFieldImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textFieldImage.contentMode = .scaleAspectFit
        textFieldImage.clipsToBounds = true
        let image = UIImage(named: "lupeT")
        textFieldImage.image = image
        testTextFeld.leftView = textFieldImage
        
        searchDataView.layer.cornerRadius = 25
        searchDataView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        searchDataView.clipsToBounds = true
        
        let attributeRadius = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let attributeZip = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let zipAttribute = NSAttributedString(string: "Postleitzahl", attributes: attributeZip)
        let radiusAttribute = NSAttributedString(string: "Radius km", attributes: attributeRadius)
        radiusDataTextField.attributedPlaceholder = radiusAttribute
        zipTextField.attributedPlaceholder = zipAttribute
        
        radiusDataTextField.backgroundColor = .clear
        zipTextField.backgroundColor = .clear
        
        radiusDataTextField.textColor = .white
        radiusDataTextField.tintColor = .white
        zipTextField.textColor = .white
        zipTextField.tintColor = .white
        
        
        
//        let sbt = searchController.searchBar.searchTextField
//
//        sbt.backgroundColor = UIColor(red: 0/61, green: 0/61, blue: 0/61, alpha: 0.61)
//        sbt.tintColor = .white
//        sbt.textColor = .white
//        sbt.placeholder = "-> Suche dein Handwerksprodukt <-"
//        searchController.searchBar.barTintColor = .purple
//        sbt.attributedPlaceholder = NSAttributedString.init(string: "Suche dein Handwerksprodukt", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
//        sbt.backgroundColor = .purple
//        sbt.tintColor = .white
//        sbt.layer.borderColor = sbt.tintColor.cgColor
//        sbt.layer.borderWidth = 1
        responViewOverZipButton.isHidden = false
        
        searchBarSec.layer.cornerRadius = searchBarSec.bounds.height/2
//        searchBarButton.layer.cornerRadius = searchBarButton.bounds.height/2
        
        
        viewNoteZipCode.isHidden = true
        viewNoteZipCode.layer.shadowColor = UIColor.white.cgColor
        viewNoteZipCode.layer.shadowOffset = CGSize(width: 50, height: 50)
        viewNoteZipCode.layer.shadowRadius = 50.0
        viewNoteZipCode.layer.shadowOpacity = 1.0
        viewNoteZipCode.layer.masksToBounds = false
        viewNoteZipCode.clipsToBounds = false
        viewNoteZipCode.backgroundColor = .clear
        
        labelZipCode.backgroundColor = .clear
        labelZipCode.layer.cornerRadius = 5
        labelZipCode.clipsToBounds = true
        labelZipCode.tintColor = buttonColor
        labelZipCode.layer.borderColor = labelZipCode.tintColor.cgColor
        labelZipCode.layer.borderWidth = 2
        
        countryCodeTextField.tintColor = .white
        countryCodeTextField.textColor = .white
        countryCodeTextField.font = UIFont.boldSystemFont(ofSize: 24)
        countryCodeTextField.attributedPlaceholder = NSAttributedString(string: "Postleitzahl", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        searchSecondButton.setTitleColor(viewBackgroundColor, for: .normal)
        let searchTitle = "suchen"
        searchSecondButton.setTitle(searchTitle, for: .normal)
        
        setupRadiusTwoFif()
        radiusTwoFiftyButton.isEnabled = false
        radiusTwoFiftyButton.layer.cornerRadius = radiusTwoFiftyButton.bounds.height/2
        
        setupRadiusFifButton()
        radiusFifButton.isEnabled = false
        radiusFifButton.layer.cornerRadius = radiusFifButton.bounds.height/2
        
        setupRadiusOneButton()
        radiusOneButton.isEnabled = false
        radiusOneButton.layer.cornerRadius = radiusOneButton.bounds.height/2
        
        setupRadiusTwoButton()
        radiusTwoButton.isEnabled = false
        radiusTwoButton.layer.cornerRadius = radiusTwoButton.bounds.height/2
        
//        searchSecondButton.backgroundColor = UIColor(red: 255/0, green: 255/139, blue: 255/139, alpha: 1.0)
        setupSearchSecondButton()
        searchSecondButton.layer.cornerRadius = searchSecondButton.bounds.height/2
        searchSecondButton.isEnabled = false
    }
    
    // MARK: - View Default Settings
    func radiusDefaultButtons() {
        radiusTwoFiftyButton.isEnabled = false
        radiusFifButton.isEnabled = false
        radiusOneButton.isEnabled = false
        radiusTwoButton.isEnabled = false
        responViewOverZipButton.isHidden = false
        
        notEnabeldSSB()
        
        radiusTwoFiftyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusFifButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusOneButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusTwoButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        
        radiusTwoFiftyButton.layer.borderWidth = 0
        radiusFifButton.layer.borderWidth = 0
        radiusOneButton.layer.borderWidth = 0
        radiusTwoButton.layer.borderWidth = 0
    }
    
    func confirmRadius() {
        radiusTwoFiftyButton.isEnabled = true
        radiusFifButton.isEnabled = true
        radiusOneButton.isEnabled = true
        radiusTwoButton.isEnabled = true
        responViewOverZipButton.isHidden = true
        
        enabledSSB()
        
        radiusTwoFiftyButton.backgroundColor = buttonColor
        radiusFifButton.backgroundColor = buttonColor
        radiusOneButton.backgroundColor = buttonColor
        radiusTwoButton.backgroundColor = buttonColor
    }
    
    func enabledSSB() {
        searchSecondButton.isEnabled = true
        searchSecondButton.backgroundColor = buttonColor
//        underlineSearchButton.backgroundColor = buttonColor
    }
    
    func notEnabeldSSB() {
        searchSecondButton.isEnabled = false
        searchSecondButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
//        underlineSearchButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
    }
    
    // MARK: - Choose Radius Button
    func addTargetToRadiusButton() {
        countryCodeTextField.addTarget(self, action: #selector(chooseRadiusButton), for: .editingChanged)
    }
    
    @objc func chooseRadiusButton() {
        if zipTextField.text?.count ?? 0 > 4 {
            guard let zipCode = zipTextField.text else { return }
            _zipCode = zipCode
            confirmRadius()
//            gecoderSetup()
        } else {
            radiusDefaultButtons()
        }
    }
    
    func setupSearchSecondButton() {
        searchSecondButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        searchSecondButton.setTitleColor(viewBackgroundColor, for: .normal)
//        underlineSearchButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
    }
    
    func setupRadiusTwoFif() {
//        radiusTwoFiftyButton.layer.borderWidth = 1
//        radiusTwoFiftyButton.layer.borderColor = radiusTwoFiftyButton.tintColor.cgColor
//        radiusTwoFiftyButton.tintColor = .white
        radiusTwoFiftyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusTwoFiftyButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func setupRadiusFifButton() {
//        radiusFifButton.layer.borderColor = radiusFifButton.tintColor.cgColor
//        radiusFifButton.tintColor = .white
//        radiusFifButton.layer.borderWidth = 1
//        radiusFifButton.backgroundColor = .clear
        radiusFifButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusFifButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func setupRadiusOneButton() {
//        radiusOneButton.layer.borderColor = radiusOneButton.tintColor.cgColor
//        radiusOneButton.tintColor = .white
//        radiusOneButton.layer.borderWidth = 1
//        radiusOneButton.backgroundColor = .clear
        radiusOneButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusOneButton.setTitleColor(viewBackgroundColor, for: .normal)
        
    }
    
    func setupRadiusTwoButton() {
//        radiusTwoButton.layer.borderColor = radiusOneButton.tintColor.cgColor
//        radiusTwoButton.tintColor = .white
//        radiusTwoButton.layer.borderWidth = 1
//        radiusTwoButton.backgroundColor = .clear
        radiusTwoButton.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        radiusTwoButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func clearRadiusTwentyFiveButton() {
//        radiusTwoFiftyButton.layer.borderWidth = 1
//        radiusTwoFiftyButton.layer.borderColor = radiusTwoFiftyButton.tintColor.cgColor
//        radiusTwoFiftyButton.tintColor = .white
//        radiusTwoFiftyButton.backgroundColor = .clear
        radiusTwoFiftyButton.layer.borderWidth = 0
//        radiusTwoFiftyButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func clearRadiusFiftyButton() {
//        radiusFifButton.layer.borderWidth = 1
//        radiusFifButton.layer.borderColor = radiusFifButton.tintColor.cgColor
//        radiusFifButton.tintColor = .white
//        radiusFifButton.backgroundColor = .clear
        radiusFifButton.layer.borderWidth = 0
//        radiusFifButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func clearRadiusOneHundredButton() {
//        radiusOneButton.layer.borderWidth = 1
//        radiusOneButton.layer.borderColor = radiusOneButton.tintColor.cgColor
//        radiusOneButton.tintColor = .white
//        radiusOneButton.backgroundColor = .clear
        radiusOneButton.layer.borderWidth = 0
//        radiusOneButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func clearRadiusTwoHundredButton() {
//        radiusTwoButton.layer.borderWidth = 1
//        radiusTwoButton.layer.borderColor = radiusTwoButton.tintColor.cgColor
//        radiusTwoButton.tintColor = .white
//        radiusTwoButton.backgroundColor = .clear
        radiusTwoButton.layer.borderWidth = 0
//        radiusTwoButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    func test () {
        countryCodeTextField.addTarget(self, action: #selector(testZuTest), for: .touchCancel)
    }
    
    @objc func testZuTest() {
        print("textField Touch funktoniert YEEEEEEES-----")
    }
    
    
    
    // MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        
        
//        searchController.searchBar.endEditing(true)
        searchBarSec.endEditing(true)
        testTextFeld.endEditing(true)
        resultTableView.isHidden = true
        
        if testTextFeld.isEditing == true {
            
        }
        
        if testTextFeld.isFirstResponder == true {
            
        }
        
        
    }
    
    
    
//    @objc func searchFieldDidChange(_ textField: UISearchBar) {
//        if let text: String = searchBarTextField.text {
//            DispatchQueue.main.async {
//                self.searchBarTextField.text = text.lowercased()
//            }
//        }
//    }
    
    // MARK: - Load user
    func loadForWillDisplay() {
        PostApi.shared.timestampTest(time: homeTimestamp) { (post) in
            self.posts.append(post)
            print("zeig mir die Time -> From1970 -> \(post.secondsFrom1970) && Date \(post.postDate)")
            if post.secondsFrom1970 != nil {
                self.homeTimestamp = post.secondsFrom1970!
            }
            self.mainCollectionViewCell.reloadData()
        }
    }
    
    func loadPosts() {
        // der aller ECHTE
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.mainCollectionViewCell.translatesAutoresizingMaskIntoConstraints = false
//            self.mainCollectionViewCell.frame.size.width -= 80
////            self.mainCollectionViewCell.contentOffset.x -= 80
//            self.isLoading = true
//            self.activityIndicatorView.startAnimating()
//            self.activityIndicatorView.isHidden = false
//        }
        
//        PostApi.shared.observePosts { (post) in
//            self.posts.insert(post, at: 0)
//            self.mainCollectionViewCell.reloadData()
//            self.activityIndicatorView.stopAnimating()
//            self.activityIndicatorView.isHidden = true
//        }
        
        self.isLoading = true
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.isHidden = false
        
        PostApi.shared.timestampTest(time: homeTimestamp) { (post) in
            self.posts.append(post)
            if post.secondsFrom1970 != nil {
                self.homeTimestamp = post.secondsFrom1970!
            }
            self.mainCollectionViewCell.reloadData()
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.isLoading = false
        }
        
        
        
//        PostApi.shared.fetchALimitOfPosts { (post) in
//            self.posts.insert(post, at: 0)
//            self.mainCollectionViewCell.reloadData()
//            self.activityIndicatorView.stopAnimating()
//            self.activityIndicatorView.isHidden = true
//        }
    }
    
//    func fetchPosts(uid: String, completed: @escaping () -> Void) {
//        UserApi.shared.observeUser(uid: uid) { (user) in
//            self.users.insert(user, at: 0)
//            completed()
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let nav = self.navigationController?.navigationBar
//        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
//        imageView.contentMode = .scaleAspectFit
//        
//        let image = UIImage(named: "project1")
//        imageView.image = image
//
//        navigationItem.titleView = imageView
//
//    }
    
    func removeTheTesterSearch() {
        testSuche.removeAll()
        testerSucheZwei.removeAll()
    }
    
    // MARK: - Navigation Bar Setup
    func navigationTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        
        return label
    }
    
    // MARK: - Action
    
    @IBAction func searchBarButtonTapped(_ sender: UIButton) {
        searchBarSec.isHidden = false
//        searchBarButton.isHidden = true
        searchBarSec.becomeFirstResponder()
    }
    
    
    @IBAction func radiusTwoFiftyButtonTapped(_ sender: UIButton) {
        if radiusTwoFiftyButton.backgroundColor != .white {
//            radiusTwoFiftyButton.backgroundColor = .white
            radiusTwoFiftyButton.setTitleColor(viewBackgroundColor, for: .normal)
            radiusTwoFiftyButton.layer.borderColor = radiusFifButton.tintColor.cgColor
            radiusTwoFiftyButton.tintColor = .white
            radiusTwoFiftyButton.layer.borderWidth = 3
            clearRadiusFiftyButton()
            clearRadiusOneHundredButton()
            clearRadiusTwoHundredButton()
            radiusChoosed = 25.0
            radiusText = "25"
            downlaodUserData()
        }
    }
    
    @IBAction func radiusFifButtonTapped(_ sender: UIButton) {
        if radiusFifButton.backgroundColor != .white {
//            radiusFifButton.backgroundColor = .white
            radiusFifButton.setTitleColor(viewBackgroundColor, for: .normal)
            radiusFifButton.layer.borderColor = radiusFifButton.tintColor.cgColor
            radiusFifButton.tintColor = .white
            radiusFifButton.layer.borderWidth = 3
            clearRadiusTwoHundredButton()
            clearRadiusOneHundredButton()
            clearRadiusTwentyFiveButton()
            radiusChoosed = 50.0
            radiusText = "50"
            downlaodUserData()
        }
    }
    
    @IBAction func radiusOneButtonTapped(_ sender: UIButton) {
        if radiusOneButton.backgroundColor != .white {
//            radiusOneButton.backgroundColor = .white
            radiusOneButton.setTitleColor(viewBackgroundColor, for: .normal)
            radiusOneButton.layer.borderColor = radiusFifButton.tintColor.cgColor
            radiusOneButton.tintColor = .white
            radiusOneButton.layer.borderWidth = 3
            clearRadiusTwentyFiveButton()
            clearRadiusFiftyButton()
            clearRadiusTwoHundredButton()
            radiusChoosed = 100.0
            radiusText = "100"
            downlaodUserData()
        }
    }
    
    @IBAction func radiusTwoButtonTapped(_ sender: UIButton) {
        if radiusTwoButton.backgroundColor != .white {
//            radiusTwoButton.backgroundColor = .white
            radiusTwoButton.setTitleColor(viewBackgroundColor, for: .normal)
            radiusTwoButton.layer.borderColor = radiusFifButton.tintColor.cgColor
            radiusTwoButton.tintColor = .white
            radiusTwoButton.layer.borderWidth = 3
            clearRadiusTwentyFiveButton()
            clearRadiusFiftyButton()
            clearRadiusOneHundredButton()
            radiusChoosed = 200.0
            radiusText = "200"
            downlaodUserData()
        }
    }
    
    @IBAction func searchSecondButtonTapped(_ sender: UIButton) {
//        guard let text = searchController.searchBar.text else { return }
        guard let text = searchBarSec.text else { return }
        search = text
        textOfMySearch = text
//        print("search", search)
//        print("was Steht Da Im Text \(countryCodeTextField.text)")
        guard let zipCode = zipTextField.text else { return }
        _zipCode = zipCode
//        print("underline ZipCode -> -> \(_zipCode)")
        _postId.removeAll()
        _postText.removeAll()
//        performSegue(withIdentifier: "ShowPostVC", sender: nil)
        performSegue(withIdentifier: "showTheResult", sender: nil)
        resultTableView.isHidden = true
//        searchBar.endEditing(true)
//        print("-------geeeesssssssucht")
        if resultTableViewHeight.constant != 175 {
            resultTableViewHeight.constant = 175.0
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowPostVC" {
//            let show = segue.destination as! SearchPostViewController
//
//            show.searchId = search
//            show._postText = postText
//            show._postId = postId
//
//            print("SEEEEEEEEGUE",search.count)
//        }
//    }
    
    @IBAction func unwindToHomeVC(_ unwindSegue: UIStoryboardSegue) {
        _postText = ""
        _postId = ""
        tappedPost.removeAll()
        searchBarSec.text = ""
        toCompareRadius.removeAll()
        print("bist du der BACK oder was")
        print("bist du der doppelte count toCompareRadius 2-> \(company.count)")
//        filterPosts.removeAll()
        
    }
    
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowPostVC" {
//            let postInfoVC = segue.destination as! SearchPostViewController
//            postInfoVC.cardPostText = self.postText
//            postInfoVC.cardSearchText = self.search
//            postInfoVC._radiusChoosed = self.radiusChoosed
//            postInfoVC.idWhereSearched = self.testSuche
//            print("__Search \(self.testSuche.count)")
//            for index in testSuche {
//
//            }
//            postInfoVC.uidWhereSearched = self.testerSucheZwei
//            postInfoVC.zipCode = self._zipCode
//            print("search +++ \(search)")
//
//            if postText != "" {
//                postInfoVC.myTextSearch = self.postText
//            } else if search != "" {
//                postInfoVC.myTextSearch = self.search
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTheResult" {
            let resultVC = segue.destination as! SearchResultViewController
            resultVC.backButtonTargetId = "unwindToHomeVC"
            
            if _postText != "" {
                resultVC.seguePost = tappedPost
                resultVC.searchText = _postText
            } else if _linkFromFirebase != "" {
                resultVC.seguePost = tappedPost
                resultVC.searchText = "Geteilter Inhalt"
                _linkFromFirebase = ""
            } else {
                resultVC.seguePost = filterPosts
                print("ich bin raus -> Übergabe \(filterPosts.count)")
                if filterPosts.count == 0 {
                    resultVC.searchText = "Leider nichts gefunden innerhalb deines Radius"
                } else {
                    resultVC.searchText = search
                }
                
            }
            
            resultVC.segueCompany = segueFromCompanyId
            resultVC.zipString = "\(self._zipCode)"
            resultVC.radiusString = radiusText
            
            print("zipCode -> \(_zipCode) &&& radius -> \(radiusText)")
            
        }
    }
}

// MARK: - CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return posts.count > 10 ? 10 : posts.count
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPostCollectionViewCell", for: indexPath) as! AllPostCollectionViewCell
//        print("Image Collection -------§§§ -- \(mainCollectionViewCell.frame.height)")
        constraintCheck()
        cell.post = posts[indexPath.row]
        cell.delegate = self
        
//        cell.contentView.layer.cornerRadius = 20
//        cell.contentView.clipsToBounds = true
        //cell.blurSetup()
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 20.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false
        
        
        
        return cell
        
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if self.isLoading {
//            return CGSize.zero
//        } else {
//            return CGSize(width: 10, height: mainCollectionViewCell.bounds.size.height)
//        }
//    }
}

// MARK: - CollectionView FlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = collectionView.frame.width / 1.60 - 1
        let height: CGFloat = collectionView.frame.height / 1.00 - 1

        let size = CGSize(width: width, height: height)



        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if indexPath.row == self.posts.count - 1 {
                self.loadForWillDisplay()
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let leftspace = 10
        let numberOfItems = collectionView.numberOfSections
        let cellSpacing = numberOfItems * leftspace
        
//        print("-----bist du der Schlingel ??? ______ ")
//        let inset = (collectionView.layer.frame.)
        return UIEdgeInsets(top: 0, left: CGFloat(cellSpacing), bottom: 0, right: CGFloat(cellSpacing))
        
//        return UIEdgeInsets(top: 0, left: CGFloat(leftspace), bottom: 0, right: CGFloat(leftspace))
    }
}

// MARK: - TableView Datasource & Delegate

//extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // bei den func´s wurde overrride entfernt -> fyi
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let selectedProduct: PostModel!
//
//        let tableViews: UITableViewController
//
//        if tableView === tableViews {
//
//        } else {
//            selectedProduct = resultTableController.searching[indexPath.row]
//        }
//
//        tableView.deselectRow(at: indexPath, animated: false)
//
//    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//    }


    // Table View im 2 akt entfertn 01.02.20

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
//
//        let search = searchs[indexPath.row]
//
//        cell.textLabel?.text = search.postText
//
//
//        return cell
//    }
//}

// MARK: - ShowCellDelegate
extension HomeViewController: ShowViewCellDelegate {
    func didTappedShow(postUid: String, text: String, uid: String) {
        print("TableView Search ____ Tap erfolgt \(postUid)")
        
//        // Für alte Version das löschen bis Ende
//        testSuche.removeAll()
//        testerSucheZwei.removeAll()
//        // Ende
//
//        self.search = text
//
//        // Für alte Version das löschen bis Ende
//        testSuche.append(postUid)
//        testerSucheZwei.append(uid)
//        // Ende
//
//
//        _postId.removeAll()
//        _postText.removeAll()
//        performSegue(withIdentifier: "ShowPostVC", sender: self)
        
        self._postText = text
        self._postId = postUid
        PostApi.shared.observePost(withPodId: _postId) { tableViewTabbed in
            self.tappedPost.append(tableViewTabbed)
            self.performSegue(withIdentifier: "showTheResult", sender: nil)
            self.view.endEditing(true)
        }
        search.removeAll()
        resultTableView.isHidden = true
        if resultTableViewHeight.constant != 175 {
            resultTableViewHeight.constant = 175.0
        }
    }
}

// MARK: - ShowCollectionDelegate
extension HomeViewController: ShowCollectionDelegate {
    func didTappedColl(postText: String, postId: String) {
        self._postText = postText
        self._postId = postId
        print("funktioniert der Tapp 1 -  \(postText) && \(postId)")
        PostApi.shared.observePost(withPodId: _postId) { postTapped in
            self.tappedPost.append(postTapped)
            self.performSegue(withIdentifier: "showTheResult", sender: nil)
        }
        search.removeAll()
        
//        searchBarPost()
//        tappedSearch()
//        print("search -> !!! \(search.count)")
//        print("tapped karten")
//        performSegue(withIdentifier: "ShowPostVC", sender: self)
//        performSegue(withIdentifier: "sho wTheResult", sender: nil)
    }
}

//extension HomeViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}

// MARK: - ResultTableView
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if searchController.isActive && searchController.searchBar.text != "" {
        if searchBarSec.text != "" {
            cellCounter = filterPosts.count
            dynamicTableViewHigh()
            print("was für ein TableViewCount filterPosts \(filterPosts.count)")
            return filterPosts.count
        }
//        print(">>>>>>posted \(posted.count)")
        print("was für ein TableViewCount postedCount \(posted.count)")
        return posted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell {
//            print("filterPost##### --- \(filterPosts.count)")
            
            // if searchController.isActive && searchController.searchBar.text != "" {
            if searchBarSec.text != "" {
                removeTheTesterSearch()
                print("was für ein CountCell \(cell.post?.count) && filterPosts \(filterPosts.count)")
                cell.post = filterPosts[indexPath.row]
//                testSuche.append((cell.post?.postText)!)
                cell.backgroundColor = .darkGray
//                print("#11111")
//                print("\(cell.post?.postText)")
                for index in filterPosts {
                    testSuche.append(index.postId!)
                    testerSucheZwei.append(index.uid!)
                    for i in testSuche {
//                        print("--testSuche --- \(i)")
                    }
                }
            } else {
                cell.post = posted[indexPath.row]
                cell.backgroundColor = .darkGray
                cellCounter = posted.count
                cell.delegate = self
//                print("#33333")
                removeTheTesterSearch()
            }
            
//            if cellCounter == 0 && resultTableViewHeight.constant == 43.75 {
//                cell.textLabel?.text = "blöd für dich"
//            }
            
            return cell
        }
        return UITableViewCell()
    }
}





// MARK: - Search Result Controller
extension HomeViewController: UISearchResultsUpdating {

    

//    func filterResult(searchText: String) {
//
//        filterPosts = posted.filter { post in
////            print("filterPosts ist voll ##### \(filterPosts.count)")
//            return post.postText!.lowercased().contains(searchText.lowercased())
//        }
//        resultTableView.reloadData()
////        print("reload TableView @@@@@")
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        filterResult(searchText: searchController.searchBar.text!)
//    }
    
    // 2. - Version von TableSearch
//    func updateSearchResults(for searchController: UISearchController) {
//        let result = filterPosts
//        let whitespaceCharacterSet = CharacterSet.whitespaces
//        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
//        let searchItem = strippedString.components(separatedBy: " ") as [String]
//
//        //        let matchPredicates: [NSPredicate] = searchItem.map { searchString in
//        //            posted(searchString: searchString)
//        //        }
//
////        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: <#T##[NSPredicate]#>)
//
//        if let resultController = searchController.searchResultsController as? HomeViewController {
//            resultController.resultTableView.reloadData()
//
//            resultController.re
//        }
//
//    }
    
    // Version V3
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
//        searchController.searchBar.text = searchBarSec.text
//        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//            print("search_+++ 1.o")
//            filterPosts = posted.filter { (tester) in
//                 tester.postText!.localizedCaseInsensitiveContains(searchText)
//
//            }
//        } else if _postText != "" {
//            filterPosts = posted.filter({ (tappedText) in
//                tappedText.postText!.localizedCaseInsensitiveContains(_postText)
//            })
//        } else {
//            filterPosts = posted
//            print("search_ 2.o")
//        }
//        resultTableView.reloadData()
    }
    

}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
