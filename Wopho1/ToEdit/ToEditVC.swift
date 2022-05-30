//
//  ToEditVC.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 16.09.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MessageUI
import Network


class ToEditVC: UIViewController, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UICollectionViewDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: - var || let
    var companyPost = [PostModel]()
    var secCompanyPost = [PostModel]()
    var _userMail = ""
    var segueIndex: Int = 0
    var isEdited = false
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if collectionView.visibleCells.isEmpty == true {
            print("machst du hier ärger//")
            collectionView.scrollToItem(at: IndexPath(item: segueIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    
    func testerDerTester() {
        secCompanyPost = companyPost
        collectionView.reloadData()
        print("indexForSegue -START> to EditVC -> \(segueIndex)")
        if secCompanyPost.count == segueIndex + 1 {
            print("indexForSegue -> to EditVC -> \(segueIndex)")
            collectionView.scrollToItem(at: IndexPath(item: segueIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    
    func reloadTheEditText(id: String) {
        let _id = id
        for (index, item) in companyPost.enumerated() {
            if _id == item.postId {
                print("Array index oder index \(index) && item \(item.postId)")
                companyPost.remove(at: index)
                let id = _id
                let _index = index
                PostApi.shared.observePost(withPodId: id) { postUpdate in
                    self.companyPost.insert(postUpdate, at: _index)
                    self.collectionView.reloadData()
                    print("editVC ReloadData - 2")
                }
            }
        }
    }
    
    func deleteTheCell(id: String) {
        let _id = id
        for (index, item) in companyPost.enumerated() {
            if _id == item.postId {
                companyPost.remove(at: index)
                collectionView.reloadData()
                print("editVC ReloadData - 3")
//                let id = _id
//                let _index = index
//                PostApi.shared.observePost(withPodId: id) { post in
//                    self.collectionView.reloadData()
//                }
            }
        }
    }
    
    // MARK: - Keyboard Settings
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
    }
    
    // MARK: - ScrollView Setup
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = collectionView.visibleCells
        
        for c in cell {
            let currentCell = c as! ToEditCollectionView
            currentCell.zoomBegin()
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = collectionView.visibleCells
        for c in cell {
            let currentCell = c as! ToEditCollectionView
            currentCell.zoomEnd()
        }
    }
    
    // MARK: - Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        print("update Time - 3 \(isEdited)")
        performSegue(withIdentifier: "unwindFromEditVC", sender: self)
    }
}

extension ToEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowEditCell", for: indexPath) as! ToEditCollectionView
        cell.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        cell.post = companyPost[indexPath.row]
        cell.mailForDelete = _userMail
        
        cell.delegateEditMode = self
        cell.delegateForEdit = self
        cell.delegateForDelete = self
        cell.delegateEditIt = self
        
        return cell
    }
}

extension ToEditVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 4, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (4 / 2), bottom: 0, right: (4 / 2))
    }
}

extension ToEditVC: postIdDelegate {
    func editCellTextField(postId: String, edited: Bool) {
        let _id = postId
        reloadTheEditText(id: _id)
        isEdited = edited
        print("update Time - 2 \(isEdited)")
    }
}

extension ToEditVC: deletePostDelegate {
    func cellDelete(postId: String, edited: Bool) {
        let _id = postId
        deleteTheCell(id: _id)
        isEdited = edited
    }
}

extension ToEditVC: editItDelegate {
    func editIt(edit: Bool) {
        if edit == true {
            backButton.tintColor = UIColor(white: 0.5, alpha: 0.7)
            backButton.isEnabled = false
            collectionView.isUserInteractionEnabled = false
        } else {
            backButton.isEnabled = true
            collectionView.isUserInteractionEnabled = true
            backButton.tintColor = .white
        }
    }
}


