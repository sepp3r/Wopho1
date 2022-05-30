//
//  AllPostCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 23.12.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage

protocol ShowCollectionDelegate {
    func didTappedColl(postText: String, postId: String)
}

class AllPostCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Layout
    @IBOutlet weak var postImageCell: UIImageView!
    @IBOutlet weak var postImageBlur: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - var/let
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            updateCellView(post: _post)
        }
    }
    
    // MARK: - functions
    func updateCellView(post: PostModel) {
        categoryLabel.text = post.postText
//        categoryLabel.textColor = .black
        setupCollView()
        guard let url = URL(string: post.imageUrl!) else { return }
        postImageCell.sd_setImage(with: url) { (_, _, _, _) in
        }
        postImageBlur.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleColl))
        postImageCell.addGestureRecognizer(tapGesture)
        postImageCell.isUserInteractionEnabled = true
        //postImageCell.contentMode = .scaleAspectFit
        postImageCell.layer.cornerRadius = 10
        postImageCell.clipsToBounds = true
//        categoryLabel.addGestureRecognizer(tapGesture)
//        categoryLabel.isUserInteractionEnabled = true
        blurSetup()
    }
    
    // MARK: - Show example Information
    var delegate: ShowCollectionDelegate?
    
    @objc func handleColl() {
        guard let postText = post?.postText else { return }
//        guard let postId = post?.id else { return }
        guard let postId = post?.postId else { return }
        delegate?.didTappedColl(postText: postText, postId: postId)
        print("funktioniert der Tapp 2 - \(postText) && \(postId)")
//        print("Collection Tapp funtzt --<-<-<-<-<-<-<-")
    }
    
    // MARK: - CollectionView Setup
    func setupCollView() {
        categoryLabel.tintColor = .white
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        categoryLabel.adjustsFontSizeToFitWidth = true
        //postImageCell.contentMode = .scaleToFill
        postImageCell.layer.cornerRadius = 10
        postImageCell.clipsToBounds = true
        
        postImageCell.layer.masksToBounds = true
        
        //blurSetup()
        
        print("___test__categoryLabel \(categoryLabel.debugDescription)")
        
    }
    
    func blurSetup() {
        let blueEffectImage = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectImageView = UIVisualEffectView(effect: blueEffectImage)
        blurEffectImageView.frame = postImageBlur.bounds
        blurEffectImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        postImageBlur.addSubview(blurEffectImageView)
        postImageBlur.layer.cornerRadius = 10
        postImageBlur.clipsToBounds = true
        postImageBlur.backgroundColor = .clear
        postImageBlur.layer.masksToBounds = true
    }
    
}
