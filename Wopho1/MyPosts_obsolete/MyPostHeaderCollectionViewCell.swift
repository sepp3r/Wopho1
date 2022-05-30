//
//  MyPostHeaderCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 08.10.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage

class MyPostHeaderCollectionViewCell: UICollectionViewCell {
    
    
    // Mark: - Outlet
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companynameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    
    // MARK: - var / let
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupUserInformation(user: _user)
        }
    }
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    override func awakeFromNib() {
        setupView()
    }
    
    
    // MARK: - Setup View
    func setupView() {
        companyImageView.layer.cornerRadius = 5
//        postCountLabel.layer.cornerRadius = postCountLabel.bounds.height/2
//        postCountLabel.backgroundColor = UIColor(red: 205/255, green: 173/255, blue: 0/255, alpha: 1.0)#
        postCountLabel.layer.cornerRadius = postCountLabel.bounds.height/2
        postCountLabel.backgroundColor = .white
        postCountLabel.layer.borderWidth = 3
        postCountLabel.tintColor = truqButtonColor
        postCountLabel.layer.borderColor = postCountLabel.tintColor.cgColor
        postCountLabel.textColor = truqButtonColor
        
        
    }
    
    // MARK: - functions
    func setupUserInformation(user: UserModel) {
        companynameLabel.text = user.username
        
        guard let url = URL(string: user.companyImageUrl!) else { return }
        companyImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
        
        PostApi.shared.fetchPostCount(withUid: user.uid!) { (postCount) in
//            print("<<<<postCount>>>>",user.uid!)
//            self.postCountLabel.text = "\(postCount)"
            
        }
    }
    
    
    
    
}
