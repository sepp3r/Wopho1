//
//  ShowCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 16.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData
import MessageUI
import SDWebImage

protocol SearchCellDelegate {
    func tappedSearch(useruid: String, postId: String, indexPath: Int)
}

//protocol ShowViewCellDelegate {
//    func didTappedShow(postUid: String)
//}

class ShowCollectionViewCell: UICollectionViewCell, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var coreDataArray = [CompanyUser]()
    var coreDataString = ""
    var saveCoreId = ""
    
    var buttonImage: UIImage!
    
    var delegate: ShowViewController!
    var mail = ""
    var postTextForMail = ""
    var user = [UserModel]()
    
    var indexPostId = ""
    var indexRow: Int = 0
    
    var search: PostModel? {
        didSet {
            guard let _search = search else { return }
//            print("<_____SEARCH________>",search?.postText)
            updateCellView(search: _search)
        }
    }
    
    func updateCellView(search: PostModel) {
        loadCoreData()
        cellSetup()
        saveCoreId = search.id!
        fetchCoreData()
        if let _uid = search.uid {
            companyInformation(userUid: _uid)
        }
        
        if let _postText = search.postText {
            postTextForMail = _postText
        }
        
        guard let url = URL(string: search.imageUrl!) else { return }
        showImage.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    func companyInformation(userUid: String) {
        UserApi.shared.observeUser(uid: userUid) { (data) in
            self.user.append(data)
            
            if let _mail = data.email {
                self.mail = _mail
            }
        }
    }
    
    override func awakeFromNib() {
        let tapGestureForPostImage = UITapGestureRecognizer(target: self, action: #selector(handlePost))
        showImage.addGestureRecognizer(tapGestureForPostImage)
        showImage.isUserInteractionEnabled = true
    }
    
    var delegatePostImage: SearchCellDelegate?
    
    @objc func handlePost() {
        guard let _userUid = search?.uid else { return }
        guard let _postId = search?.postId else { return }
        
        print("INDEX wer <-> cellIndex \(indexRow) && postId \(search?.postId)")
        
        delegatePostImage?.tappedSearch(useruid: _userUid, postId: _postId, indexPath: indexRow)
    }
    
    // MARK: - Setup Cell
    func cellSetup() {
//        buttonImage = UIImage(systemName: "starwWithBlack2.0")
        buttonImage = UIImage(named: "starwWithBlack2.0")
        
        likeButton.setImage(buttonImage, for: .normal)
        likeButton.isEnabled = true
        likeButton.tintColor = .white
        likeButton.backgroundColor = .clear
        likeButton.setTitleColor(.white, for: .normal)
        likeButton.contentMode = .scaleAspectFill
        
//        let mailImage = UIImage(systemName: "mailWithBlack")
        let mailImage = UIImage(named: "mailWithBlack")
        mailButton.setImage(mailImage, for: .normal)
        mailButton.isEnabled = true
        mailButton.tintColor = .white
        mailButton.backgroundColor = .clear
        mailButton.setTitleColor(.white, for: .normal)
        mailButton.contentMode = .scaleAspectFill
        
        showImage.layer.cornerRadius = 10
        showImage.clipsToBounds = true
        
         
        
    }
    
    // MARK: - Mail Setup
    
    func successMail() {
        let _mail = MFMailComposeViewController()
        _mail.mailComposeDelegate = self
        _mail.setToRecipients([mail])
        _mail.setSubject("Anfrage Inserat aus App_Name")
        _mail.setMessageBody(" Hallo, ich interessiere mich für Ihren Post >>> \(postTextForMail)", isHTML: false)
        self.delegate.present(_mail, animated: true, completion: nil)
        
    }
    
    func mailError() {
        let error = UIAlertController(title: "Mail Programm konnte nicht geöffnet werden", message: "Bitte prüfen sie ihre Mail Einstellung", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            self.delegate.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.mailError()
            self.delegate.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.delegate.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    // MARK: - Core Data - Load - Save - Delete - Error
    func fetchCoreData() {
        for index in  coreDataArray {
            print("postUid - \(index.postUid) && id - \(search?.id)")
            if index.postUid == search?.id {
                buttonImage = UIImage(named: "starWithLike")
                likeButton.setImage(buttonImage, for: .normal)
                likeButton.contentMode = .scaleAspectFill
                continue
            }
        }
    }
    
    func deleteCollect() {
        for index in coreDataArray {
            print("company Array -Versuch zu gelöscht \(index.postUid) && \(search?.id)")
            if index.postUid == search?.id {
                let coreIndex = index.self
                CoreData.defaults.context.delete(coreIndex)
                CoreData.defaults.saveContext()
                print("company Array gelöscht erfolgreich")
                continue
            } else {
//                errorDeleteCoreData()
                print("company Array gelöscht error")
            }
        }
    }
    
    func errorDeleteCoreData() {
        let error = UIAlertController(title: "Hinweis", message: "Like konnte nicht gelöscht werden", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    
    func loadCoreData() {
        let coreDataArray = CoreData.defaults.loadData()
        if let _coreDataArray = coreDataArray {
            self.coreDataArray = _coreDataArray
        } else {
            errorLoadCoreData()
        }
    }
    
    func errorLoadCoreData() {
        let error = UIAlertController(title: "Hinweis", message: "Like konnte nicht geladen werden", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    func saveCoreData() {
        print("company Array SAVE - SHOWCOLLE \(saveCoreId)")
        if saveCoreId.count != 0 {
            let postId = CoreData.defaults.createData(_postUid: saveCoreId)
        } else {
            errorCoreDateSave()
        }
    }
    
    func errorCoreDateSave() {
        let error = UIAlertController(title: "Hinweis", message: "Like konnte nicht gespeichert werden", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    // MARK: - Like Button Process
    
    func checkWhichImageLike() {
        if buttonImage == UIImage(named: "starWithLike") {
            buttonImage = UIImage(named: "starwWithBlack2.0")
            likeButton.setImage(buttonImage, for: .normal)
            likeButton.contentMode = .scaleAspectFill
            print("company Array delte")
            deleteCollect()
        } else {
            buttonImage = UIImage(named: "starWithLike")
            likeButton.setImage(buttonImage, for: .normal)
            likeButton.contentMode = .scaleAspectFill
            saveCoreData()
            loadCoreData()
            print("company Array save")
        }
    }
    
    
    // MARK: - Action
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            self.successMail()
        } else {
            self.mailError()
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        checkWhichImageLike()
    }
    
}
