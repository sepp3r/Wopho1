//
//  UserCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.05.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import MessageUI

protocol PostImageDelegate {
    func tappedImage(userUid: String, postId: String, indexPath: Int)
}

protocol DeleteInfo {
    func tappedDelete()
}

class UserCollectionViewCell: UICollectionViewCell, MFMailComposeViewControllerDelegate {
    
    // MARK: - Layout
    @IBOutlet weak var postCardImage: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var myLikeButton: UIButton!
    
//    enum Storage {
//        case userDefault
//        case fileSystems
//    }
    
    var coreDataArry = [CompanyUser]()
    var coreDataString = ""
    var saveCoreId = ""
    
    var buttonImage: UIImage!
    
    var delegate: UserViewController!
    
    var cellPhone = ""
    var mobilePhone = ""
    var receiver = ""
    var postText = ""
    var indexRow: Int = 0
    
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupUserInfo(user: _user)
        }
    }
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            setupCellView(post: _post)
        }
    }
    
    var coreData: CompanyUser? {
        didSet {
            guard let _coreDate = coreData else { return }
            setupCoreData(coreData: _coreDate)
        }
    }
    
    
    
    func setupTest(derTest: [String]) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureShowPostImage = UITapGestureRecognizer(target: self, action: #selector(handleShowPost))
        postCardImage.addGestureRecognizer(tapGestureShowPostImage)
        postCardImage.isUserInteractionEnabled = true
        
        myLikeButton.translatesAutoresizingMaskIntoConstraints = false
        let _center = myLikeButton.centerXAnchor.constraint(equalTo: postCardImage.centerXAnchor)
        NSLayoutConstraint.activate([_center])
    }
    
    var delegatePostImage: PostImageDelegate?
    
    @objc func handleShowPost() {
        
        guard let _userUid = post?.uid else { return }
        guard let _postId = post?.id else { return }
        
        delegatePostImage?.tappedImage(userUid: _userUid, postId: _postId, indexPath: indexRow)
    }
    
    var delegateForDelete: DeleteInfo?
    
    func handleDelete() {
        delegateForDelete?.tappedDelete()
    }
    
    func setupUserInfo(user: UserModel) {
        print("cellPhone -1-1- \(user.phone)")
        if user.phone != nil {
            cellPhone = user.phone!
            print("cellPhone --- \(cellPhone)")
        }
        print("mobilePhone -2-2- \(user.mobilePhone)")
        if user.mobilePhone != nil {
            mobilePhone = user.mobilePhone!
            print("mobilePhone --- \(mobilePhone)")
        }
        
        if user.email != nil {
            receiver = user.email!
            
        }
    }
    
    func setupCellView(post: PostModel) {
        loadCoreData()
        cellSetup()
//        fetchCoreData()
//        loadCoreData()
        
        if let _postText = post.postText {
            postText = _postText
        }
        
        saveCoreId = post.id!
        guard let url = URL(string: post.imageUrl!) else { return }
        postCardImage.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    func setupCoreData(coreData: CompanyUser) {
        
    }
    
    // MARK: - email Setup
    
    func showMailError() {
        let error = UIAlertController(title: "Email konnte nicht gesendet werden", message: "Bitte prüfen sie ihre Email-Einstellung", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            self.delegate.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.showMailError()
            self.delegate.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.delegate.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    // MARK: - Phone Setup
    
    func phoneCallSetup() {
        if cellPhone.count != 0 && mobilePhone.count != 0 {
            let urlLandline: NSURL = NSURL(string: "tel://\(cellPhone)")!
            let urlMobile: NSURL = NSURL(string: "tel://\(mobilePhone)")!
            let alert = UIAlertController(title: "Hinweis", message: nil, preferredStyle: .actionSheet)
            let firstNumber = UIAlertAction(title: "Festnetz", style: .default) { (action) in
                UIApplication.shared.open(urlLandline as URL, options: [:], completionHandler: nil)
            }
            let secondNumber = UIAlertAction(title: "Mobilfunk", style: .default) { (action) in
                UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
            }
            
            alert.addAction(firstNumber)
            alert.addAction(secondNumber)
            self.delegate.present(alert, animated: true, completion: nil)
        } else if cellPhone.count != 0 {
            if let url = URL(string: "tel://\(cellPhone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else if mobilePhone.count != 0 {
            if let urlMobile = URL(string: "tel://\(mobilePhone)"), UIApplication.shared.canOpenURL(urlMobile) {
                UIApplication.shared.open(urlMobile, options: [:], completionHandler: nil)
            }
        } else {
            let error = UIAlertController(title: "Hinweis!", message: "Keine Nummer hinterlegt", preferredStyle: .alert)
            error.addAction(UIAlertAction(title: "zurück", style: .cancel, handler: nil))
            self.delegate.present(error, animated: true, completion: nil)
        }
    }
    
    // 1. Variante
//    func getImage(image: String) {
//        let fileManager = FileManager.default
//
//        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString).appendingPathComponent(image)
//
//        if fileManager.fileExists(atPath: imagePath) {
//            postCardImage.image = UIImage(contentsOfFile: imagePath)
//        } else {
//            print("funktioniert nicht")
//        }
//    }
//
//    private func filePath(forKey key:String) -> URL? {
//        let fileManager = FileManager.default
//        guard let URL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
//
//        return URL.appendingPathComponent(key + ".png")
//    }
    
    // 2. Variante
//    private func retrieveImage(forKey key: String, inStorageType storageType: Storage) -> UIImage? {
//        switch storageType {
//        case .fileSystems:
//            if let filePaths = self.filePath(forKey: key),
//                let fileData = FileManager.default.contents(atPath: filePaths.path),
//                let image = UIImage(data: fileData) {
//                return image
//            }
//        case .userDefault:
//            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
//                let image = UIImage(data: imageData) {
//
//                return image
//            }
//        }
//
//        return nil
//    }
//
//    func display() {
//        DispatchQueue.global(qos: .background).async {
//            if let saveImage = self.retrieveImage(forKey: "image", inStorageType: .fileSystems) {
//                DispatchQueue.main.async {
//                    self.postCardImage.image = saveImage
//                }
//
//            }
//        }
//    }
    
    // MARK: - Setup Cell
    func cellSetup() {
        phoneButton.isEnabled = true
        phoneButton.tintColor = .white
//        phoneButton.layer.borderColor = phoneButton.tintColor.cgColor
//        phoneButton.layer.borderWidth = 1
        phoneButton.backgroundColor = .clear
        phoneButton.setTitleColor(.white, for: .normal)
//        phoneButton.layer.cornerRadius = phoneButton.bounds.height/2
        
        let mailImage = UIImage(named: "mailWithBlack")
        mailButton.setImage(mailImage, for: .normal)
        mailButton.isEnabled = true
        mailButton.tintColor = .white
//        mailButton.layer.borderColor = mailButton.tintColor.cgColor
//        mailButton.layer.borderWidth = 1
        mailButton.backgroundColor = .clear
        mailButton.setTitleColor(.white, for: .normal)
//        mailButton.layer.cornerRadius = mailButton.bounds.height/2
        
        postCardImage.layer.cornerRadius = 10
        postCardImage.clipsToBounds = true
        
        myLikeButton.isEnabled = true
        myLikeButton.tintColor = .white
        myLikeButton.backgroundColor = .clear
        myLikeButton.setTitleColor(.white, for: .normal)
//        buttonImage = UIImage(systemName: "star.fill")
        buttonImage = UIImage(named: "starWithLike")
        myLikeButton.setImage(buttonImage, for: .normal)
        myLikeButton.contentMode = .scaleAspectFill
    }
    
    func fetchCoreData() {
        for index in coreDataArry {
            print("postUid - \(index.postUid) && id - \(post?.id)")
            if index.postUid == post?.id {
                buttonImage = UIImage(named: "starWithLike")
                myLikeButton.setImage(buttonImage, for: .normal)
                myLikeButton.contentMode = .scaleAspectFill
                continue
            }
        }
    }
    
    // MARK: CoreData Load - Save Delete - error
    func deleteCollect() {
        for index in coreDataArry {
            print("company Array -VersuchWUNSCH zu gelöscht \(index.postUid) && \(post?.id)")
            if index.postUid == post?.id {
                let coreIndex = index.self
                CoreData.defaults.context.delete(coreIndex)
                CoreData.defaults.saveContext()
                handleDelete()
                continue
            } else {
                print("error Alert")
            }
        }
    }
    
//    func coreCellHidden() {
//        for index in coreDataArry {
//            if index.postUid == post?.id &&
//        }
//    }
    
    func loadCoreData() {
        let coreDataArray = CoreData.defaults.loadData()
        if let _coreDataArry = coreDataArray {
            self.coreDataArry = _coreDataArry
        }
    }
    
    func saveCoreData() {
        print("company Array SAVE - USERLib \(saveCoreId)")
        if saveCoreId.count != 0 {
            let postId = CoreData.defaults.createData(_postUid: saveCoreId)
        } else {
            error()
        }
    }
    
    func error() {
        let error = UIAlertController(title: "Hinweis", message: "Like konnte nicht gespeichert werden", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    // MARK: - Change Button Images
    func imageMyLikeButton() {
        if buttonImage == UIImage(named: "starWithLike") {
            buttonImage = UIImage(named: "starwWithBlack2.0")
            myLikeButton.setImage(buttonImage, for: .normal)
            myLikeButton.contentMode = .scaleAspectFill
            deleteCollect()
            print("ich bin da mal weg---- delete")
        } else {
            buttonImage = UIImage(named: "starWithLike")
            myLikeButton.setImage(buttonImage, for: .normal)
            myLikeButton.contentMode = .scaleAspectFill
            saveCoreData()
        }
    }
    
    // macht bis jetzt keine Sinn -> löschen
    func imagePhoneButton() {
        if buttonImage == UIImage(systemName: "phone.fill") {
            buttonImage = UIImage(systemName: "phone")
            phoneButton.setImage(buttonImage, for: .normal)
        } else {
            buttonImage = UIImage(systemName: "phone.fill")
            phoneButton.setImage(buttonImage, for: .normal)
        }
    }
    
    // macht bis jetzt keine Sinn -> löschen
    func imageMailButton() {
        if buttonImage == UIImage(systemName: "envelope.fill") {
            buttonImage = UIImage(systemName: "envelope")
            mailButton.setImage(buttonImage, for: .normal)
        } else {
            buttonImage = UIImage(systemName: "envelope.fill")
            mailButton.setImage(buttonImage, for: .normal)
        }
    }
    
    // MARK: - Information
    
    func noteForDeletedPost() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
        }
    }
    
    
    // MARK: - Action
    @IBAction func phoneButtonTapped(_ sender: UIButton) {
        phoneCallSetup()
    }
    
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([receiver])
            mail.setSubject("Anfrage Inserat bei App....")
            mail.setMessageBody("Ich interessiere mich für Ihren Post >>>  \(postText)", isHTML: false)
            self.delegate.present(mail, animated: true, completion: nil)
        } else {
            self.showMailError()
        }
    }
    
    
    @IBAction func myLikeButtonTapped(_ sender: UIButton) {
        imageMyLikeButton()
    }
    
    
    
}
