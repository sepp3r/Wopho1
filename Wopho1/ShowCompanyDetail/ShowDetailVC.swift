//
//  ShowDetailVC.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 26.07.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData
import CoreLocation
import MessageUI
import Network

class ShowDetailVC: UIViewController, MFMailComposeViewControllerDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UICollectionViewDelegate {
    
    // MARK: - Layout
    @IBOutlet weak var collectionViewCell: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companyImageBlur: UIImageView!
    
    @IBOutlet weak var streetImage: UIImageView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var underlineHeaderView: UIView!
    
    @IBOutlet weak var constraintTopBackButton: NSLayoutConstraint!
    
    
    // MARK: - var || let
    var posts = [PostModel]()
    var seguePost = [PostModel]()
    
    
    
    var segueCompany: [String] = []
    lazy var gecoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    var zipString = ""
    var radiusString = ""
    var searchText = ""
    var shareIdFromFirbase = ""
    
//    var userId = [UserModel]()
    var user: UserModel?
    var segueUserId = ""
    var seguePostText = ""
    var segueIndex: Int = 0
    
    
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    override func viewDidLoad() {
        collectionViewCell.delegate = self
        collectionViewCell.dataSource = self
        
        loadCompanyPost()
        fetchCompanyId()
        headerSetup()
        
        if UIDevice.current.hasNotch {
        } else {
            constraintTopBackButton.constant = -5
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Download from Database
    func loadCompanyPost() {
        PostApi.shared.observeMyPost(withUid: segueUserId) { (Id) in
            PostApi.shared.observePost(withPodId: Id) { (postId) in
                self.posts.insert(postId, at: 0)
                self.collectionViewCell.reloadData()
                if self.posts.count == self.segueIndex + 1 {
                    self.collectionViewCell.scrollToItem(at: IndexPath(item: self.segueIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    func fetchCompanyId() {
        UserApi.shared.observeUser(uid: segueUserId) { (companyId) in
            self.user = companyId
            self.collectionViewCell.reloadData()
            
            if let _companyName = companyId.username {
                self.companyLabel.text = _companyName
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
                self.infoLabel.text = companyId.textForEverything
            } else {
                self.infoImage.isHidden = true
                self.infoLabel.isHidden = true
            }
            
            guard let url = URL(string: companyId.companyImageUrl!) else { return }
            self.companyImage.sd_setImage(with: url) { _, _, _, _ in
            }
            
//            self.companyImageBlur.sd_setImage(with: url) { _, _, _, _ in
//            }
            
        }
    }
    
    // MARK: Setup
    
    func headerSetup() {
        companyImage.layer.cornerRadius = companyImage.bounds.width/2
        companyImage.clipsToBounds = true
        companyLabel.tintColor = .white
        streetLabel.tintColor = .white
        zipLabel.tintColor = .white
        cityLabel.tintColor = .white
        infoLabel.tintColor = .white
        
//        let blueEffectImage = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
//        let blurEffectImageView = UIVisualEffectView(effect: blueEffectImage)
//        blurEffectImageView.frame = companyImageBlur.bounds
//        blurEffectImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        companyImageBlur.addSubview(blurEffectImageView)
//        companyImageBlur.layer.cornerRadius = 10
//        companyImageBlur.clipsToBounds = true
//        companyImageBlur.backgroundColor = .clear
        
        streetLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        zipLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        cityLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    // MARK: - Scroll View Setup
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = collectionViewCell.visibleCells
        
        for c in cell {
            let currentCell = c as! ShowCompanyCell
            currentCell.buttonAndLabelAlpaZero()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = collectionViewCell.visibleCells
        
        for c in cell {
            let currentCell = c as! ShowCompanyCell
            currentCell.buttonAndLabelAlphaOne()
        }
    }
    
    
    // MARK: - Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToShow", sender: self)
    }
    
    
    
}

extension ShowDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCompanyCell", for: indexPath) as! ShowCompanyCell
        cell.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        cell.delegateShowDetail = self
        cell.detailPosts = posts[indexPath.row]
        
        return cell
    }
}

extension ShowDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 4, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (4 / 2), bottom: 0, right: (4 / 2))
    }
}
