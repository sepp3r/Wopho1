//
//  SearchResultViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 07.05.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseDynamicLinks
import CoreData
import CoreLocation
import LinkPresentation
import MessageUI
import Network

class SearchResultViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    
    // MARK: - Outlet
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var radius: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    // MARK: - var || let
    var posts = [PostModel]()
    var seguePost = [PostModel]()
    var tappedPostFromHome = [PostModel]()
//    var segueCompany = [UserModel]()
    var segueCompany: [String] = []
    lazy var gecoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    var zipString = ""
    var radiusString = ""
    var searchText = ""
    var shareIdFromFirebase = ""
    
    var wishlist = ""
    
    var tappedUserId = ""
    var tappedPostId = ""
    var tappedPostText = ""
    
    var reachedIndexFromWish: Int = 0
    
    var backButtonTargetId = ""
    
    var counterOfPost = 0
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        collectionViewSetup()
        //loadAllPost()
        loadIncomingShare()
        radiusData()
        print("incoming share_ 2 \(shareIdFromFirebase)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        if shareIdFromFirebase == "" {
            if wishlist == "wishlist" {
                if resultCollectionView.visibleCells.isEmpty == true {
                    resultCollectionView.scrollToItem(at: IndexPath(item: reachedIndexFromWish, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let tabBarController = self.ShowViewController as UITabBarController {
//                tabBarController.selectedIndex = 1
//            }
        if segue.identifier == "segueShowVC" {
            let showCompanyVC = segue.destination as! ShowViewController
            
            showCompanyVC._userUid = self.tappedUserId
            showCompanyVC._postText = self.tappedPostText
            showCompanyVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            showCompanyVC.tabBarController?.tabBar.isHidden = false
            
            
            
            //self.present(showCompanyVC, animated: true, completion: nil)
            //self.tabBarController?.navigationController?.pushViewController(showCompanyVC, animated: true)
//            showCompanyVC.hidesBottomBarWhenPushed = false
//            self.navigationController?.pushViewController(showCompanyVC, animated: true)
            
//            guard let tabBar = window?.rootViewController as? UITabBarController else { return }
//
//            tabBar.tabBarController?.tabBar.isHidden = false
//
//            tabBar.present(showCompanyVC, animated: true) {
//            }

//            segue.destination.tabBarController?.present(showCompanyVC, animated: true, completion: {
//
//            })
            
            
            
//            segue.destination.navigationController?.pushViewController(showCompanyVC, animated: true)
            
            
            //navigationController?.pushViewController(showCompanyVC, animated: true)
//            navigationController?.present(showCompanyVC, animated: true, completion: {
//                
//            })
            
//            let barViewController = segue.destination as! UITabBarController
//            let nav = barViewController.viewControllers![0] as! UINavigationController
//            let destinationVC = nav.topViewController as! ShowViewController
//
//            destinationVC._userUid = self.tappedUserId
//            destinationVC._postText = self.tappedPostText
        }
    }
    
    // MARK: - Incoming Share
    func getPostForId(postId: String) {
        print("incoming share_ 1 \(shareIdFromFirebase)")
        shareIdFromFirebase = postId
    }
    
    
    // MARK: - Setup
    func collectionViewSetup() {
        counter.layer.cornerRadius = counter.bounds.height/2
        counter.backgroundColor = truqButtonColor
        counter.clipsToBounds = true
        
        zip.layer.cornerRadius = zip.bounds.height/2
        zip.backgroundColor = truqButtonColor
        zip.clipsToBounds = true
        zip.text = zipString
        
        radius.layer.cornerRadius = radius.bounds.height/2
        radius.backgroundColor = truqButtonColor
        radius.clipsToBounds = true
        radius.text = radiusString
        
        searchLabel.text = searchText
        
    }
    
    func infoByUserLibrary() {
    }
    
    func radiusData() {
        print("Radius_Data ZIP - \(zipString.count) ++ Radius_String - \(radiusString)")
        if zipString.count == 5 && radiusString != "" {
            radius.isHidden = false
            radiusLabel.isHidden = false
            zip.isHidden = false
            zipLabel.isHidden = false
            zip.frame.size.width = 40
            zip.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            zip.translatesAutoresizingMaskIntoConstraints = true
            zip.backgroundColor = truqButtonColor
             
            print("radiusData ZIP - hidden false")
        } else {
            radius.isHidden = true
            radiusLabel.isHidden = true
//            zip.isHidden = true
//            zipLabel.isHidden = true
            zip.text = "Deutschland"
            zip.frame.size.width = 80
            zip.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            zip.backgroundColor = .clear
            zip.translatesAutoresizingMaskIntoConstraints = true
            print("radiusData ZIP - hidden true")
        }
        
        var width: CGFloat = 0.0
        switch seguePost.count {
        case 0...9:
            width = 15.0
        case 11...99:
            width = 25.0
        case 100...999:
            width = 35.0
        case 1000...9999:
            width = 40.0
        default:
            width = 60.0
        }
        counter.frame.size.width = width
        print("frame Counter__ \(counter.frame.width) ++ seguePost.count \(seguePost.count)")
        counter.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    
    
    
    // MARK: - Backend
    func loadAllPost() {
        PostApi.shared.observePosts { (post) in
            self.posts.insert(post, at: 0)
            print("incoming share ID__0.0 \(self.posts.count)")
            self.resultCollectionView.reloadData()
            self.radiusData()
        }
    }
    
    func loadIncomingShare() {
        print("incoming share 2 \(shareIdFromFirebase)")
        if shareIdFromFirebase != "" {
            PostApi.shared.observePost(withPodId: shareIdFromFirebase) { post in
                self.seguePost.insert(post, at: 0)
                self.backButtonTargetId = "unwindToHomeVC"
                self.resultCollectionView.layoutIfNeeded()
                self.resultCollectionView.reloadData()
                self.searchLabel.text = "Geteilter Inhalt"
                print("incoming share Ende")
            }
        } else if searchLabel.text == "Deine Wunschliste" {
            self.resultCollectionView.reloadData()
            //self.resultCollectionView.layoutSubviews()
            print("Wunschlist Problem - seguePost -> \(seguePost.count) && Count Index \(reachedIndexFromWish)")
            if seguePost.count != 0 {
                
            }
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = resultCollectionView.visibleCells
        
        for c in cell {
            let currentCell = c as! SearchResultCVC
            currentCell.buttonAndLabelAlpaZero()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = resultCollectionView.visibleCells
        for c in cell {
            let currentCell = c as! SearchResultCVC
            currentCell.buttonAndLabelAlphaOne()
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: - Action
    
    @IBAction func unwindDefault(_ unwindSegue: UIStoryboardSegue) {
        print("awake funtzt oder was 1")
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        searchLabel.text = ""
        if backButtonTargetId == "unwindToHomeVC" {
            shareIdFromFirebase = ""
            wishlist = ""
            performSegue(withIdentifier: "unwindToHomeVC", sender: self)
        } else if backButtonTargetId == "unwindToUserVC" {
            shareIdFromFirebase = ""
            wishlist = ""
            performSegue(withIdentifier: "unwindToUserVC", sender: self)
        }
    }
    
    
    
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.seguePost.count == 0 {
            if searchLabel.text != "Leider nichts gefunden innerhalb deines Radius" {
                self.searchLabel.text = "Inhalt leider nicht mehr verfügbar"
                self.backButtonTargetId = "unwindToHomeVC"
            }
        }
        return seguePost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCVC", for: indexPath) as! SearchResultCVC
        
        cell.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        counter.text = "\(seguePost.count)"
        cell.delegateZoom = self
        cell.delegateEndOfZomm = self
        cell.delegateSearchResultVC = self
        cell.company = segueCompany
        cell.post = seguePost[indexPath.row]
        cell.tappedImageDelegate = self
        print("cardFrameHigh --------!!!!!!:::::: card cell \(cell.frame)")
//        cell.company = segueCompany[indexPath.row]
        print("incoming share ID__3 \(cell.post?.count)")
        print("wie oft bewegst du dich \(cell.frame.origin.x)")
        
        return cell
        
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width : CGFloat = collectionView.frame.width / 1.02 - 1
//        let height: CGFloat = collectionView.frame.height / 1.00 - 1
//        let size = CGSize(width: width, height: height)
//        print("size of cell\(size)")
//        return size
        return CGSize(width: UIScreen.main.bounds.width - 4, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

//        let leftspace = 3
//        let numbersOfItems = collectionView.numberOfSections
//        let cellSpacing = numbersOfItems * leftspace
//
//        print("size of cell ___ REchnung  \(cellSpacing)")
//
//        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        return UIEdgeInsets(top: 0, left: (4 / 2), bottom: 0, right: (4 / 2))
        
    }
}

extension SearchResultViewController: zoomNotification {
    func zoom() {
//        resultCollectionView.clipsToBounds = false
//        resultCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        print("test zoom111")
        resultCollectionView.isScrollEnabled = false
        resultCollectionView.clipsToBounds = false
    }
    
    
}

extension SearchResultViewController: zoomNotifyEnd {
    func zoomEnding() {
        resultCollectionView.isScrollEnabled = true
        resultCollectionView.clipsToBounds = true
    }
}

extension SearchResultViewController: tappedImage {
    func tapping(userUid: String, postText: String, postId: String) {
        self.tappedUserId = userUid
        self.tappedPostText = postText
        self.tappedPostId = postId
        
        print("bekommt er die daten 1 \(tappedUserId) 2 \(tappedPostText) 3 \(tappedPostId)")
        performSegue(withIdentifier: "segueShowVC", sender: self)
        
    }
    
    
}
