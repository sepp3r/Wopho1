//
//  ShareViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 24.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Photos
import PhotosUI
import SDWebImage
import CoreHaptics

class ShareViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var toolBarBlurEffect: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageToShare: UIImageView!
    @IBOutlet weak var textFieldToShare: UITextField!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIButton!
    
//    @IBOutlet weak var toolBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarWidthConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - var || let
    private var engine: CHHapticEngine?
    var newImageFromLibrary: UIImage?
    var storagePostTheId = ""
    var toolBarX: CGFloat = 0.0
    var toolBarAniX: CGFloat = 0.0
    var timer: Timer?
    var stringForUnwind = ""
    
    let buttonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    let redButtonColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    let darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    
    override func viewDidLoad() {
        print("where is notify _1 \(self.notifyLabel.frame) && hidden \(self.notifyLabel.isHidden)")
        textFieldToShare.returnKeyType = .send
        textFieldToShare.delegate = self
        textFieldToShare.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        setupView()
        print("toolBar -> start ->  \(self.toolBar.transform)")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        textFieldToShare.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "letShowPreviewVC" {
            let showPreviewVC = segue.destination as! PreviewViewController
            showPreviewVC.returnImage = nil
            showPreviewVC.incomeSegue = "ShowPreviewVC"
            print("ist segue der Fehler START")
        }
    }
    
    // MARK: - Keyboard Settings
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count ?? 0 > 0 {
            textFieldToShare.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startIndicator()
                self.uploadData()
            }
        } else {
            view.endEditing(true)
        }
        
        return true
    }
    
    // MARK: - Setup View
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textFieldToShare.text?.count ?? 0 > 0 {
            confirmToUpload()
        } else {
            notConfirmToUpload()
        }
    }
    
    func setupView() {
        imageToShare.contentMode = UIView.ContentMode.scaleAspectFit
        imageToShare.clipsToBounds = true
        imageToShare.image = newImageFromLibrary
        
        galleryButton.layer.cornerRadius = galleryButton.bounds.width / 2
        galleryButton.clipsToBounds = true
        galleryButton.imageView?.tintColor = buttonColor
        galleryButton.backgroundColor = .white
        galleryButton.layer.borderWidth = 2
        galleryButton.tintColor = buttonColor
        galleryButton.layer.borderColor = galleryButton.tintColor.cgColor
        
        textFieldToShare.tintColor = UIColor.lightGray
        textFieldToShare.layer.borderWidth = 1
        textFieldToShare.layer.borderColor = UIColor.lightGray.cgColor
        
        toolBar.layer.cornerRadius = 5
        toolBar.clipsToBounds = true
        toolBarBlurEffect.clipsToBounds = true
        
        notifyLabel.isHidden = true
        notifyLabel.backgroundColor = redButtonColor
        notifyLabel.adjustsFontSizeToFitWidth = true
        
        
        defaultIndicatorSetup()
        
        cameraButton.layer.cornerRadius = cameraButton.bounds.width / 2
        cameraButton.clipsToBounds = true
        cameraButton.imageView?.tintColor = buttonColor
        cameraButton.backgroundColor = .white
        cameraButton.layer.borderWidth = 2
        cameraButton.tintColor = buttonColor
        cameraButton.layer.borderColor = cameraButton.tintColor.cgColor
        
        notConfirmToUpload()
        abortButtonSetup()
    }
    
    func confirmToUpload() {
        let imageShare = UIImage(systemName: "paperplane")
        shareButton.setImage(imageShare, for: .normal)
        shareButton.imageView?.tintColor = .white
        shareButton.backgroundColor = buttonColor
        shareButton.layer.borderWidth = 3
        shareButton.tintColor = darkgrayButtonColor
        shareButton.layer.borderColor = shareButton.tintColor.cgColor
        shareButton.layer.cornerRadius = shareButton.bounds.height/2
        shareButton.isEnabled = true
    }
    
    func notConfirmToUpload() {
        let imageShare = UIImage(systemName: "paperplane")
        shareButton.setImage(imageShare, for: .normal)
        shareButton.imageView?.tintColor = darkgrayButtonColor
        shareButton.tintColor = darkgrayButtonColor
        shareButton.layer.borderWidth = 0
        shareButton.backgroundColor = .clear
        shareButton.isEnabled = false
    }
    
    func abortButtonSetup() {
        let imageAbort = UIImage(systemName: "xmark")
        abortButton.setImage(imageAbort, for: .normal)
        abortButton.imageView?.tintColor = darkgrayButtonColor
        abortButton.backgroundColor = redButtonColor
        abortButton.layer.borderWidth = 3
        abortButton.tintColor = darkgrayButtonColor
        abortButton.layer.borderColor = abortButton.tintColor.cgColor
        abortButton.layer.cornerRadius = abortButton.bounds.height/2
    }
    
    func abortSetup() {
//        performSegue(withIdentifier: "backToCameraVC", sender: self)
        imageToShare.image = nil
        textFieldToShare.text = ""
        notConfirmToUpload()
        abortButtonSetup()
    }
    
    // MARK: - Haptic Setup
    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Upload Setup
    func uploadData() {
        guard let image = newImageFromLibrary else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let imageId = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(imageId)
        storagePostTheId = imageId
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                self.uploadError()
            }
            storageRef.downloadURL { url, error in
                if error != nil {
                    return
                }
                let profilImageUrlString = url?.absoluteString
                self.uploadDataToDatabase(imageUrl: profilImageUrlString ?? "Kein Bild vorhanden")
            }
        }
    }
    
    func uploadDataToDatabase(imageUrl: String) {
        let databaseRef = Database.database().reference().child("posts")
        let newPostId = databaseRef.childByAutoId().key
        let newPostReference = databaseRef.child(newPostId!)
        let postId = newPostId
        let storagePostId = storagePostTheId
        let postTime = Date().timeIntervalSince1970
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        let dic = ["uid" : userUid, "imageUrl" : imageUrl, "postText" : textFieldToShare.text, "postId" : postId, "storagePostId" : storagePostId, "postTime" : postTime] as [String : Any]
        
        newPostReference.setValue(dic) { (error, ref) in
            if error != nil {
                self.uploadError()
                return
            }
            PostApi.shared.REF_MY_POSTS.child(userUid).child(newPostId!).setValue(true)
            self.stopIndicatorSuccessful()
        }
    }
    
    // MARK: - Timer Setup
    
    func startIndicator() {
//        view.endEditing(true)
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.animateIndicator), userInfo: nil, repeats: false)
            abortButton.isHidden = true
            shareButton.isHidden = true
            galleryButton.isHidden = true
            cameraButton.isHidden = true
            toolBarBlurEffect.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                self.toolBar.frame.size.width -= 286
                self.toolBarWidthConstraint.constant -= 286
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
                        self.toolBar.center.x = self.view.center.x
                        self.toolBarAniX = self.toolBar.center.x
    //                    self.activityIndicator.center.x = self.toolBar.center.x
                        self.activityIndicator.isHidden = false
                        self.toolBar.layer.cornerRadius = self.toolBar.frame.height/2
                    } completion: { (_) in
                    }
                }
            } completion: { (_) in
//                self.startIndicator()
            }
        }
    }
    
    func stopIndicatorSuccessful() {
        timer?.invalidate()
        timer = nil
//        self.toolBar.frame.origin.x = self.toolBarAniX
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
            self.toolBar.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
            self.toolBar.translatesAutoresizingMaskIntoConstraints = true
//            self.toolBar.center.x = self.view.center.x
        } completion: { (end) in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
                let image = UIImage(systemName: "checkmark")
                self.activityIndicator.setImage(image, for: .normal)
                self.activityIndicator.imageView?.tintColor = .black
                self.activityIndicator.backgroundColor = self.buttonColor
                self.activityIndicator.isHighlighted = true
                self.activityIndicator.layer.cornerRadius = self.activityIndicator.frame.height/2
                self.hapticSuccess()
            } completion: { (finished) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.stopAnimationSuccessful()
                }
                
            }

        }
    }
    
    func stopIndicatorError() {
        timer?.invalidate()
        timer = nil
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
            self.toolBar.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
        } completion: { (end) in
            self.stopAnimationError()
        }
    }
    
    
    
    func uploadError() {
        
        self.notifyLabel.isHidden = false
        self.toolBar.isHidden = true
        notifyLabel.translatesAutoresizingMaskIntoConstraints = true
        notifyLabel.text = "Fehler, probier es später nochmal"
        
        notifyLabel.adjustsFontSizeToFitWidth = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notifyLabel.frame.origin.x -= 254
        } completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                    self.notifyLabel.frame.origin.x += 254
                } completion: { (_) in
                    self.stopIndicatorError()
                }
            }
        }
    }
    
    func defaultIndicatorSetup() {
        let image = UIImage(systemName: "xmark")
        activityIndicator.setImage(image, for: .normal)
        activityIndicator.imageView?.tintColor = .white
        activityIndicator.backgroundColor = .clear
        activityIndicator.isHidden = true
        activityIndicator.isEnabled = false
//        toolBarX = toolBar.frame.origin.x
        toolBar.layer.cornerRadius = 5
        toolBar.clipsToBounds = true
        toolBarBlurEffect.clipsToBounds = true
    }
    
    func stopAnimationSuccessful() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
//            self.toolBar.frame.origin.x = self.toolBarX
            self.activityIndicator.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
                    self.toolBar.frame.size.width += 286
                    self.toolBarWidthConstraint.constant += 286
                    self.toolBar.layer.cornerRadius = 5
                    self.toolBarBlurEffect.clipsToBounds = true
                    self.toolBar.center.x = self.view.center.x
                } completion: { (_) in
                    self.defaultIndicatorSetup()
                    self.abortSetup()
                    
                }
            }
        } completion: { (_) in
            self.abortButton.isHidden = false
            self.shareButton.isHidden = false
            self.galleryButton.isHidden = false
            self.cameraButton.isHidden = false
            self.toolBarBlurEffect.isHidden = false
            self.textFieldToShare.isEnabled = true
            
            
            print("toolBar -> last ->  \(self.toolBar.transform)")
        }
    }
    
    func stopAnimationError() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear) {
//            self.toolBar.frame.origin.x = self.toolBarX
            self.activityIndicator.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
                    self.toolBar.frame.size.width += 286
                    self.toolBarWidthConstraint.constant += 286
                    self.toolBar.layer.cornerRadius = 5
                    self.toolBarBlurEffect.clipsToBounds = true
                    self.toolBar.center.x = self.view.center.x
                } completion: { (_) in
                }
            }
        } completion: { (_) in
            self.abortButton.isHidden = false
            self.shareButton.isHidden = false
            self.galleryButton.isHidden = false
            self.cameraButton.isHidden = false
            self.toolBarBlurEffect.isHidden = false
            self.toolBar.isHidden = false
            self.textFieldToShare.isEnabled = true
            self.notifyLabel.isHidden = true
            self.abortSetup()
            print("toolBar -> last ->  \(self.toolBar.transform)")
        }
    }
    
    
    @objc func animateIndicator() {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear) {
            self.toolBar.transform = self.toolBar.transform.rotated(by: CGFloat(Double.pi))
        } completion: { (finished) in
            if self.timer != nil {
                self.timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.animateIndicator), userInfo: nil, repeats: false)
            }
        }

    }
    
    // MARK: - Action
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        startIndicator()
        uploadData()
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "backToCameraVC", sender: self)
    }
    
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        if stringForUnwind == "backToGalleryVC" {
            performSegue(withIdentifier: "backToGalleryVC", sender: self)
        } else {
            performSegue(withIdentifier: "letShowPreviewVC", sender: self)
        }
        
        print("wird da getapped")
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        abortSetup()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "backToCameraVC", sender: self)
    }
}
