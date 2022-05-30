//
//  CategoryTableViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 25.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var picOneImageView: UIImageView!
    @IBOutlet weak var picTwoImageView: UIImageView!
    @IBOutlet weak var picThreeImageView: UIImageView!
    @IBOutlet weak var picFourImageView: UIImageView!
    @IBOutlet weak var picFiveImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            postTableViewCell(post: _post)
            
        }
    }
    
    func postTableViewCell(post: PostModel) {
        print(post)
        //categoryNameLabel.text = post.postText!
        
        guard let url = URL(string: post.imageUrl!) else { return }
        picOneImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
        
        guard let url2 = URL(string: post.imageUrl!) else { return }
        picTwoImageView.sd_setImage(with: url2) { (_, _, _, _) in
        }
        
        guard let url3 = URL(string: post.imageUrl!) else { return }
        picThreeImageView.sd_setImage(with: url3) { (_, _, _, _) in
        }
        
        guard let url4 = URL(string: post.imageUrl!) else { return }
        picFourImageView.sd_setImage(with: url4) { (_, _, _, _) in
        }
        
        guard let url5 = URL(string: post.imageUrl!) else { return }
        picFiveImageView.sd_setImage(with: url5) { (_, _, _, _) in
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
