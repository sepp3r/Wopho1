//
//  MyPostImageCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 07.10.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage

protocol PostCellDelegate {
    func tappedPost(userUid: String, postId: String)
}

class MyPostImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            updateCellView(post: _post)
        }
    }
    
    func updateCellView(post: PostModel) {
        postImageView.layer.cornerRadius = 10
        postImageView.clipsToBounds = true
        
        guard let url = URL(string: post.imageUrl!) else { return }
        
        postImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    // Image Klickbar machen
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureShowPostImage = UITapGestureRecognizer(target: self, action: #selector(handleShowPost))
        postImageView.addGestureRecognizer(tapGestureShowPostImage)
        postImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Show User Information
    var delegate: PostCellDelegate?
    
    @objc func handleShowPost() {
        
        guard let userUid = post?.uid else { return }
        guard let postId = post?.id else { return }
//        delegate?.tappedPost(userUid: userUid)
        delegate?.tappedPost(userUid: userUid, postId: postId)
        
        
    }
    
}
