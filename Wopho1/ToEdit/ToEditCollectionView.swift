//
//  ToEditCollectionView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 16.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Network
import MessageUI

protocol postIdDelegate {
    func editCellTextField(postId: String, edited: Bool)
}

protocol deletePostDelegate {
    func cellDelete(postId: String, edited: Bool)
}

protocol editItDelegate {
    func editIt(edit: Bool)
}

class ToEditCollectionView: UICollectionViewCell, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 2.5
            scrollView.minimumZoomScale = 0.95
            scrollView.backgroundColor = .clear
            scrollView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var trailingNotifyLabel: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    
    
    // MARK: - var || let
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var timer: Timer?
    var editCellImageDic: [String : String] = [:]
    var notifyLabelX: CGFloat = 0
    var saveButtonXCenter: CGFloat = 0
    var cellTextForAbort = ""
    var cellLabelText = ""
    var cellId = ""
    var checkTheCellId = ""
    var imageURLForDelete = ""
    var mailForDelete = ""
    var delegateEditMode: ToEditVC!
    var user = [UserModel]()
    var isEdit: Bool = false
    var editIsActive: Bool = false
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            updateCell(post: _post)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegateEditMode.view.endEditing(true)
        editTextField.endEditing(true)
        
    }
    
    // MARK: - ScrollView Setup
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.zoomBegin()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.zoomScale = 1
            self.zoomEnd()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cellImage
    }
    
    // MARK: - Timer Setup
    func startTheIndicator() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.animateTheIndi), userInfo: nil, repeats: false)
            binButton.isHidden = true
            abortButton.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                // Button breite ist 80 und höhe 25
                self.saveButton.translatesAutoresizingMaskIntoConstraints = true
                
                self.saveButton.frame.size.width -= 55
                self.saveButton.center = self.saveButton.center
                self.saveButton.layer.cornerRadius = self.saveButton.frame.height/2
                let image = UIImage(systemName: "xmark")
                self.saveButton.setImage(image, for: .normal)
                self.saveButton.imageView?.tintColor = .black
            } completion: { (end) in
            }

        }
    }
    
    @objc func animateTheIndi() {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear) {
            self.saveButton.transform = self.saveButton.transform.rotated(by: CGFloat(Double.pi))
        } completion: { (end) in
            if self.timer != nil {
                self.timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.animateTheIndi), userInfo: nil, repeats: false)
            }
        }

    }
    // MARK: - Setup
    func updateCell(post: PostModel) {
        print("mein Post Text updateCell COUNTER -> \(editCellImageDic.count) and id \(post.postId)")
        
        if editCellImageDic.count != 0 {
            for (text, id) in editCellImageDic {
                if post.postId == id {
                    editTextField.text = post.postText
                    print("mein Post Text ->1.1 \(editTextField.text)")
                    cellLabelText = text
                    cellTextForAbort = text
                    cellId = id
                    cellSetupForDic()
                } else {
                    editTextField.text = post.postText
                    print("mein Post Text ->2.1 \(editTextField.text)")
                    if post.postText == nil {
                        cellLabelText = "Fehler in der Darstellung"
                        print("mein Post Text ->3.1 \(cellLabelText)")
                    } else {
                        cellLabelText = post.postText!
                        cellTextForAbort = post.postText!
                        print("mein Post Text ->4.1 \(cellLabelText)")
                    }
                    
                    imageURLForDelete = post.storagePostId!
                    cellId = post.postId!
                    
                    cellSetup()
                    print("mein Post Text -> 5.1 \(cellId) && editTextFeld -- \(editTextField.alpha)")
                }
            }
        } else {
            editTextField.text = post.postText
            print("mein Post Text ->2 \(editTextField.text)")
            if post.postText == nil {
                cellLabelText = "Fehler in der Darstellung"
                print("mein Post Text ->3 \(cellLabelText)")
            } else {
                cellLabelText = post.postText!
                cellTextForAbort = post.postText!
                print("mein Post Text ->4 \(cellLabelText)")
            }
            
            imageURLForDelete = post.storagePostId!
            cellId = post.postId!
            cellSetup()
            print("mein Post Text ->5 \(cellId)")
        }
        editTextField.delegate = self
        editTextField.textColor = .white
        addTargetToEditTextField()
        guard let url = URL(string: post.imageUrl!) else { return }
        cellImage.sd_setImage(with: url) { _, _, _, _ in
        }
        
        scrollView.delegate = self
        cellImage.isUserInteractionEnabled = true
        cellImage.isMultipleTouchEnabled = true
        
        print("mein Post Text -> das ENDE --- \(cellId) && editTextFeld -- \(editTextField.alpha)")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var delegateForEdit: postIdDelegate?
    
    @objc func handleEditTextField() {
        delegateForEdit?.editCellTextField(postId: cellId, edited: isEdit)
        print("update Time - 1 \(isEdit)")
    }
    
    var delegateForDelete: deletePostDelegate?
    
    @objc func handleTheCellDelete() {
        print("wie oft läufst du ---> \(cellId)")
        delegateForDelete?.cellDelete(postId: cellId, edited: isEdit)
    }
    
    var delegateEditIt: editItDelegate?
    @objc func handleEditIt() {
        delegateEditIt?.editIt(edit: editIsActive)
    }
    
    func cellSetup() {
        print("cellSetup ___ Edit")
        editTextField.returnKeyType = .done
        editTextField.delegate = self
        editTextField.alpha = 1.0
        editTextField.adjustsFontSizeToFitWidth = true
        editTextField.tintColor = UIColor.lightGray
        editTextField.layer.borderWidth = 1
        editTextField.layer.borderColor = UIColor.lightGray.cgColor
        editTextField.isHidden = false
        cellImage.contentMode = .scaleAspectFit
        cellImage.layer.cornerRadius = 10
        cellImage.clipsToBounds = true
        cellImage.layer.masksToBounds = true
        checkButton.isEnabled = false
        checkButton.isHidden = true
        notifyLabel.isHidden = false
        notifyLabel.backgroundColor = redColor
        notifyLabelX = notifyLabel.frame.origin.x
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        buttonSetup()
    }
    
    func cellSetupForDic() {
        editTextField.alpha = 1.0
        editTextField.adjustsFontSizeToFitWidth = true
        editTextField.tintColor = UIColor.lightGray
        editTextField.layer.borderWidth = 1
        editTextField.layer.borderColor = UIColor.lightGray.cgColor
        editTextField.isHidden = false
        cellImage.contentMode = .scaleAspectFit
        cellImage.layer.cornerRadius = 10
        cellImage.clipsToBounds = true
        cellImage.layer.masksToBounds = true
        checkButton.isEnabled = false
        checkButton.isHidden = true
        notifyLabel.isHidden = false
        notifyLabel.backgroundColor = redColor
        notifyLabelX = notifyLabel.frame.origin.x
    }
    
    func buttonSetup() {
        saveButton.layer.cornerRadius = saveButton.bounds.height/2
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = .darkGray
        saveButton.setTitle("Speichern", for: .normal)
        saveButton.setTitleColor(.lightGray, for: .normal)
        saveButton.isHidden = false
        saveButton.isEnabled = false
        saveButton.alpha = 1.0
        saveButtonXCenter = saveButton.frame.origin.x
        abortButton.layer.cornerRadius = abortButton.bounds.height/2
        abortButton.clipsToBounds = true
        abortButton.backgroundColor = .darkGray
        abortButton.setTitle("Abbrechen", for: .normal)
        abortButton.setTitleColor(.lightGray, for: .normal)
        abortButton.isHidden = false
        abortButton.isEnabled = false
        abortButton.alpha = 1.0
        checkButton.isHidden = true
        editTextField.isEnabled = true
        notifyLabel.isHidden = true
        binButton.isEnabled = true
        binButton.alpha = 1.0
    }
    
    func changeToSave() {
        saveButton.backgroundColor = truqButtonColor
        saveButton.setTitle("Speichern", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.isEnabled = true
        abortButton.backgroundColor = redColor
        abortButton.setTitle("Abbrechen", for: .normal)
        abortButton.setTitleColor(.white, for: .normal)
        abortButton.isEnabled = true
    }
    
    func zoomBegin() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
            print("cellSetup ___ Edit 11111")
            self.editTextField.alpha = 0
            self.binButton.alpha = 0
            self.abortButton.alpha = 0
            self.saveButton.alpha = 0
        } completion: { _ in
        }
    }
    
    func zoomEnd() {
        editTextField.alpha = 1.0
        binButton.alpha = 1.0
        abortButton.alpha = 1.0
        saveButton.alpha = 1.0
    }
    
    // MARK: - Editing Setup
    func addTargetToEditTextField() {
        editTextField.addTarget(self, action: #selector(editTheCellText), for: .editingChanged)
    }
    
    @objc func editTheCellText() {
        if editTextField.text != cellTextForAbort {
            self.changeToSave()
            self.cellLabelText = editTextField.text!
        } else {
            self.defaultSaveButtonLayout()
        }
    }
    
    
    
    // MARK: - Haptic Setup
    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Keyboard Settings
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if editTextField.text != cellTextForAbort {
            editTextField.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.editIsActive = true
                self.startTheIndicator()
                self.uploadWork()
            }
            
        } else {
            delegateEditMode.view.endEditing(true)
        }
        
        return true
    }
    
    // MARK: - Save Setup
    
    func errorUpload() {
        notifyLabel.isHidden = false
        notifyLabel.translatesAutoresizingMaskIntoConstraints = true
        notifyLabel.text = "Fehler, konnte nicht gespeichert werden"
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notifyLabel.frame.origin.x -= 254
        } completion: { (_) in
            self.cellLabelText = self.cellTextForAbort
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                    self.notifyLabel.frame.origin.x += 254
                } completion: { (_) in
                    self.buttonSetup()
                    self.editIsActive = false
                    self.handleEditIt()
                }
            }
        }
    }
    
    func errorDelete() {
        notifyLabel.isHidden = false
        notifyLabel.translatesAutoresizingMaskIntoConstraints = true
        notifyLabel.text = "Fehler, konnte nicht gelöscht werden"
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notifyLabel.frame.origin.x -= 254
        } completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                    self.notifyLabel.frame.origin.x += 254
                } completion: { (_) in
                    self.buttonSetup()
                }
            }
        }
    }
    
    func uploadSuccessful() {
        timer?.invalidate()
        timer = nil
        print("the ID oder was")
        
        print("was ist I START-> \(editCellImageDic.count)")
        for i in editCellImageDic {
            print("was ist I -> \(i)")
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear) {
            self.saveButton.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
            self.saveButton.translatesAutoresizingMaskIntoConstraints = true
        } completion: { (end) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
                self.saveButton.setTitle(.none, for: .normal)
                let image = UIImage(systemName: "checkmark")
                self.saveButton.setImage(image, for: .normal)
                self.saveButton.imageView?.tintColor = .black
                self.saveButton.backgroundColor = self.truqButtonColor
                self.saveButton.isHighlighted = true
                self.saveButton.layer.cornerRadius = self.saveButton.frame.height/2
                self.hapticSuccess()
                self.editCellImageDic.updateValue(self.cellId, forKey: self.cellLabelText)
                print("was ist I ENDE-> \(self.editCellImageDic.count)")
                self.editTextField.text = self.cellLabelText
                self.isEdit = true
            } completion: { (finished) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    self.stopAniSuccess()
                    self.editIsActive = false
                    self.handleEditIt()
                }
                
            }
        }
//        checkButton.isHidden = false
//        saveButton.setTitle("gespeichert", for: .normal)
//        abortButton.isHidden = true
        
        
//        defaultSaveButtonLayout()
        
        
        
    }
    
    
    func stopAniSuccess() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear) {
            self.saveButton.frame.size.width += 55
            self.saveButton.setImage(.none, for: .normal)
//            self.saveButton.setTitle("", for: .normal)
        } completion: { (end) in
            self.binButton.isHidden = false
            self.abortButton.isHidden = false
            self.buttonSetup()
            self.handleEditTextField()
            
        }

    }
    
    func defaultSaveButtonLayout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            self.buttonSetup()
        }
    }
    
    func uploadWork() {
        saveButton.setTitle("", for: .normal)
        abortButton.isHidden = true
        binButton.isHidden = true
        uploadPostText()
        handleEditIt()
    }
    
    func opportunityToAbort() {
        editTextField.text = cellTextForAbort
        buttonSetup()
    }
    
    // MARK: - Save & Delete Posts
    func uploadPostText() {
        AuthenticationService.updatePostLabelText(postId: cellId, postText: cellLabelText, onSuccess: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.uploadSuccessful()
            }
            
        }) { (errorMessage) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.errorUpload()
            }
            
        }
    }
    
    func deleteThePost() {
        saveButton.setTitle("", for: .normal)
        saveButton.isEnabled = false
        saveButton.alpha = 0.2
        abortButton.setTitle("", for: .normal)
        abortButton.isEnabled = false
        abortButton.alpha = 0.2
        binButton.isEnabled = false
        binButton.alpha = 0.2
        AuthenticationService.deletePost(postId: cellId, ImageUrl: imageURLForDelete, email: mailForDelete, onSuccess: {
            
            if self.checkTheCellId == self.cellId {
                print("wie oft läufst du 2222 cehck - \(self.checkTheCellId) && cellId - \(self.cellId)")
                self.handleTheCellDelete()
            }
            self.buttonSetup()
            self.isEdit = true
        }) { (errorMessage) in
            self.errorDelete()
        }
    }
    
    // MARK: - delete Reques Alert
    
    func alertDelete() {
        let alert = UIAlertController(title: "Möchtest du wirklich deinen Post löschen?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Löschen", style: .cancel) { action in
            self.checkTheCellId = self.cellId
            self.deleteThePost()
        }
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        
        let dismiss = UIAlertAction(title: "Abbrechen", style: .default, handler: nil)
        
        alert.addAction(dismiss)
        alert.addAction(delete)
        
        self.delegateEditMode.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action
    @IBAction func binButtonTapped(_ sender: UIButton) {
        alertDelete()
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        opportunityToAbort()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("mein Post Text SAVEBUTTON-> \(cellId)")
        editIsActive = true
        startTheIndicator()
        uploadWork()
    }
}
