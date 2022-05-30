//
//  ResultTableViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

protocol ShowViewCellDelegate {
    func didTappedShow(postUid: String, text: String, uid: String)
}

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var resultTextLabel: UILabel!
    
    var post: PostModel? {
        didSet {
//            print("ttttt",post?.imageUrl?.count)
            guard let _post = post else { return }
//            print("_post ---- \(_post.count)")
            updateTableCell(post: _post)
            
        }
    }
    
    var zeroTextLabel = "" {
        didSet {
            print("Zero in the cell \(zeroTextLabel)")
            resultTextLabel.text = "blöd für dich gelaufen"
        }
    }
    

    
    // MARK: - functions
    func updateTableCell(post: PostModel) {
        
//        print("der Post Text ##### \(resultTextLabel.text)")
        if resultTextLabel.text == nil {
            print("++++++++ KEIN text gefunden")
        }
        resultTextLabel.text = post.postText
        resultTextLabel.backgroundColor = .darkGray
        resultTextLabel.textColor = .white
        resultTextLabel.layer.cornerRadius = 20
        
//        print(">_>_>_>_>_>_>_>_>resultTableViewCell--COUNTER",counter)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShow))
        resultTextLabel.addGestureRecognizer(tapGesture)
        resultTextLabel.isUserInteractionEnabled = true
        print("tEeeeeeeeeeeeeeeeeeeeeeeeeest ___ awakeFromNib")
    }
    
    override func layoutSubviews() {
        if zeroTextLabel != "" {
            resultTextLabel.text = zeroTextLabel
        }
    }
    
    func zeroSearchText() {
        resultTextLabel.text = "leider pech für dich"
    }
    
    // MARK: - Show Post Information
    var delegate: ShowViewCellDelegate?
    
    @objc func handleShow() {
        
        guard let postUid = post?.postId else { return }
        guard let _uid = post?.uid else { return }
        guard let text = post?.postText else { return }
        delegate?.didTappedShow(postUid: postUid, text: text, uid: _uid)
        print("tEeeeeeeeeeeeeeeeeeeeeeeeeest", post?.postText)
    }

}

extension ResultTableViewCell: ZeroTextDelegate {
    func zeroLabelText(zero: String) {
        print("Result ZERO geht")
        self.zeroTextLabel = zero
    }
}
