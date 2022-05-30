//
//  CompanyCollectionView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 09.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

protocol tappedDelegate {
    func tappedCell(indexPath: Int)
}

class CompanyCollectionView: UICollectionViewCell {
    
    
    // MARK: - Outlet
    @IBOutlet weak var cellImage: UIImageView!
    
    var indexRow: Int = 0
    
    var compPost: PostModel? {
        didSet {
            guard let _compPost = compPost else { return }
            updateCell(compPost: _compPost)
        }
    }
    
    func updateCell(compPost: PostModel) {
        guard let url = URL(string: compPost.imageUrl!) else { return }
        cellImage.sd_setImage(with: url) { _, _, _, _ in
        }
        cellImage.layer.cornerRadius = 10
        cellImage.clipsToBounds = true
        cellImage.contentMode = .scaleAspectFill
        print("was ist die postUid ---- \(compPost.uid)")
        
    }
    
    override func awakeFromNib() {
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(handleWithTappedCell))
        cellImage.addGestureRecognizer(tapGestureImage)
        cellImage.isUserInteractionEnabled = true
    }
    
    var delegateTappedCell: tappedDelegate?
    
    @objc func handleWithTappedCell() {
        delegateTappedCell?.tappedCell(indexPath: indexRow)
    }
    
}
