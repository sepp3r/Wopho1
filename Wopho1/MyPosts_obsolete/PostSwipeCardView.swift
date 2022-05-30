//
//  PostSwipeCardView.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 06.11.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

protocol PostTextDelegate {
    func changePostText(postId: String, postText: String)
}

protocol NativePostTextDelegate {
    func nativePosts(nativePostId: String, nativeText: String)
}

// brauchen wir nicht kann nach erfolgreich EDTI test gelöscht werden
protocol DelegateDelete {
    func delete(deleteText: String, deleteId: String, deleteUserUid: String)
}

//protocol endPostTextDelegate {
//    func endChangePostText()
//}

protocol PostDeleteDelegate {
    func deletePost(postId: String, storageId: String)
}

class PostSwipeCardView: SwipeCardViewCard, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // MARK: - outlet
    @IBOutlet var backgroundContainer: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UITextField!
    
    // MARK: - var / let
//    var delegateKeyboard: PostViewController!
    var backBack: PostViewController!
//    var stackContainer: StackContainerView!
    var initialCenter = CGPoint()
    var postIdFirstCard = ""
    
    var changePostText = ""
    var changePostId = ""
    
    var actuallyCard: [String : String] = [:]
    var actuallyPostText = ""
    var actuallyPostID = ""
    var postData = [PostModel]()
    
    
    // Test für Delete
    var textForDelete = ""
    var idForDelete = ""
    var uidForDelete = ""
    
    
    var testDelete = ""
    
    // Ende
    
    // für edit den Post text
    var editingText: [String] = []
    var editingId: [String] = []
    var counter = 0
    // ende
    
    // die geänderten Daten wieder zurück an der Karte übergeben
    var backAgainText: [String] = []
    var backAgainId: [String] = []
    // Ende
    
    // test für dictionary
    var backAgainDic: [String : String] = [:]
    // ende
    
    
    var deleteStorageId = ""
    var deletePostId = ""
    
    var post : PostModel? {
        didSet {
            guard let _post = post else { return }
            setupPostInformation(post: _post)
            print("post Information _____ \(post)")
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewSetup()
        backContainerSetup()
        backBack.cardCheckOfText = self
        postLabel.delegate = self
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesturePinch:)))
        postImage.addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = self
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesturePan:)))
        postImage.addGestureRecognizer(panGesture)
        panGesture.maximumNumberOfTouches = 2
        panGesture.minimumNumberOfTouches = 2
        
        postImage.isUserInteractionEnabled = true
        postImage.isMultipleTouchEnabled = true
        
        addTargetToResavePost()
        addTargetToDeletePost()
//        endOfTouch()
//        print("test_postText -- \(post?.postText)")
//        handlePostText()
        handleDeletePost()
        deletePostId = post!.id!
        deleteStorageId = post!.storagePostId!
//        print("backAgainId PostSwipeVC count 7777 -- \(backAgainId.count)")
//        print("77777 Counter -- \(counter)")
        //compareMode()
        secondCompareMode()
        
        // nicht nach der Reihenfolge der CardViews
//        handleDeletePost()
        
//        print("StorageId ----layoutSubview \(deleteStorageId)")
//        print("postId ----layoutSubview \(deletePostId)")
//        print("postText ----layoutSubview \(post?.postText)")
//        print("sogennante ViewDidLoad \(editingText.count)")
    }
    
    override func awakeFromNib() {
        
    }
    
    // MARK: - Setup View
    func backContainerSetup() {
        backgroundContainer.layer.cornerRadius = 20
        backgroundContainer.backgroundColor = .white
    }
    
    func viewSetup() {
        postLabel.tintColor = UIColor.black
        postLabel.textColor = UIColor.black
    }
    
    // MARK: - Dismiss Keyboard by return
    func textFieldShouldReturn(_ postLabel: UITextField) -> Bool {
        self.backBack.view.endEditing(true)
        return true
    }
    
    // MARK: - functions
    func setupPostInformation(post: PostModel) {
        
        
//        guard let postText = post.postText else { return }
//        editingText.insert(postText, at: 0)
//
//
//        for text in editingText {
//            postLabel.text = text
//        }
        
        
//        print("__!!Wie oft funktoinierst du--!!")
//        print("wich count --- \(backAgainId.count)")
//        for id in backAgainId {
//            if id == post.postId {
//                print("koooorrekt so --- \(post.postId)")
//            }
//        }
        
        
        
        postLabel.text = post.postText
        print("----------postlabel 1st Card Text \(post.postText)")
//        print("postID's the 1st------ \(post.postId)")
//        print("postID's text 11111st \(post)")
        
//        print("DER TESTER ------")
//        print("Setup Post Information \(editingText.count)")
        
        
        
        guard let url = URL (string: post.imageUrl!) else { return }
        postImage.sd_setImage(with: url) { (_, _, _, _) in
            
        }
    }
    
    func setupAbortInformation(post: PostModel) {
        
        for (text, id) in actuallyCard {
            
            print("postID \(post.postId)  && id from Return \(id)")
           if post.postId == id {
            post.postText = text
            postLabel.text = post.postText
            print("wie oft läufst du durch \(postLabel.text)")
            }
        }
        
        
    }
    
    func addTargetToResavePost() {
        postLabel.addTarget(self, action: #selector(resavePostFunc), for: .editingChanged)
    }
    
    @objc func resavePostFunc() {
        changePostId = post!.id!
        changePostText = postLabel.text!
//        print("teeeest funktoniert---- 33333 \(actuallyPostText)")
        handlePostText()
    }
    
    func addTargetToDeletePost() {
        postLabel.addTarget(self, action: #selector(backToFirstPostText), for: .touchDown)
    }
    
    // war zuvor delet funktion
    @objc func backToFirstPostText() {
        
        actuallyPostText = postLabel.text!
        actuallyPostID = post!.id!
        handleNativePost()
//        actuallyCard.updateValue(actuallyPostText, forKey: actuallyPostID)
        
        
//        print("teeeest funktoniert---- 1111 \(actuallyPostText) &&& Post Id ______ \(actuallyPostID)")
//        handlePostDelete()
        
    }
    
    
    
//    func endOfTouch() {
//        postLabel.addTarget(self, action: #selector(endTouchTheLabel), for: .editingDidEnd)
//    }
//    
//    @objc func endTouchTheLabel() {
//        endHandlePostText()
//    }
    
    // MARK: - Compare Mode
//    func compareMode() {
//        guard let postId = post?.postId else { return }
////        print("wie of zählst du durch--??--")
//        for id in backAgainId {
//            var compareCounter = 0
////            compareCounter += 1
//            print("compare Mode is on YEEEEEES 111-- \(compareCounter )")
//            if id == postId {
//                print("array count PostId --- \(id.hashValue)")
////                compareCounter -= 1
//                print("compare Mode is on YEEEEEES 222-- \(compareCounter )")
//                let text = backAgainText[compareCounter]
//                postLabel.text = text
//                break
//            }
//        }
//    }
    
    func secondCompareMode() {
        print("was ist los")
        guard let postId = post?.postId else { return }
        for (id, text) in backAgainDic {
            print("backAgainDic 2222 --- \(id) &&&& \(text)")
            if id == postId {
                postLabel.text = text
            }
        }
    }
    
    func abortProcess() {
//        let abort =
        print("Hääääääää#ä")
        print("Häääääääää#2.00000\(postLabel.text.debugDescription)")
        post = postData[2]
        
        
        
        print("postDATE \(post.debugDescription)")
        
//        setupAbortInformation(post: post!)
//
//
//
//        post?.setValue(postData, forKey: "test")
        
//        postLabel.text = post?.postText
        
        
        
        
        
//        guard let postId = post?.postId else { return }
//        for (text, id) in actuallyCard {
//            print("test actually Post ID \(id) &&&& Post Text \(text)")
//
//            if id == post?.postId {
//                post?.postText = text
//                postLabel.text = post?.postText
//                print("acutally Post text True")
//            }
//
//            for index in postData {
//
//                if index.postId == id {
//                    print("klappt auf gangzer länge \(index.postId)")
////                    post?.setValue(text, forKey: id)
//                    print("debug beschreibung ------ \(post.debugDescription)")
//
//                    postLabel.text = text
//
////                    if abort == true {
////
////                        print("text von abort func \(text)")
////                    }
////                    post?.postText?.append(contentsOf: text)
////                    post?.postText?.enumerated()
////                    postLabel.text = post?.postText
//
//                }
//            }
//
//            if id == postId {
//                postLabel.text = text
//
//            }
//        }
    }
    
    //MARK: - Pinch / Pan
    @objc func panGesture(gesturePan: UIPanGestureRecognizer) {
        let piece = gesturePan.view!
        let translation = gesturePan.translation(in: piece.superview)
        if gesturePan.state == .began {
            self.initialCenter = piece.center
        }
        if gesturePan.state == .ended {
            piece.center = initialCenter
        } else if gesturePan.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
    }
    
    @objc func pinchGesture(gesturePinch: UIPinchGestureRecognizer) {
        print("SCAAAAALE zuvor \(gesturePinch.scale)")
        if gesturePinch.state == .recognized {
            UIView.animate(withDuration: 0.2) {
                self.postImage.transform = CGAffineTransform.identity
                
            }
        } else if postImage.transform.a >= 1.0 && postImage.transform.d >= 1.0 && postImage.transform.a <= 6.0 && postImage.transform.d <= 6.0 {
            gesturePinch.view?.transform = (gesturePinch.view?.transform.scaledBy(x: gesturePinch.scale, y: gesturePinch.scale))!
            gesturePinch.scale = 1.0
            print("scale222 !!!!!!")
        }
        
        print("SCAAAAALE -----End \(gesturePinch.scale.isNormal)")
    }
    
    // Extremer ZOOM beim zweiten mal wenn vorher die Karte bewegt wurde
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    // MARK: - Save functions
    
//    func uploadPostTextData() {
//        AuthenticationService.updatePostLabelText(postId: "", postText: postLabel.text!, onSuccess: {
//            self.confirmResave()
//        }) { (errorMessage) in
//            self.errorResave()
//        }
//    }
    
    // MARK: - Resave & Delete
    var delegateHandle: PostTextDelegate?
    
    @objc func handlePostText() {
//        guard let postId = changePostId else { return }
//        guard let postText = changePostText else { return }
        let postId = changePostId
        let postText = changePostText
//        print("imageUrl -- \(post?.imageUrl) -- ")
        
        
        delegateHandle?.changePostText(postId: postId, postText: postText)
    }
    
    var delegateNativePost: NativePostTextDelegate?
    
    @objc func handleNativePost() {
        let text = actuallyPostText
        let id = actuallyPostID
        
        delegateNativePost?.nativePosts(nativePostId: id, nativeText: text)
//        print("teeeest funktoniert---- 1111 second____\(actuallyPostText) &&& Post Id ______ \(actuallyPostID)")

    }
    
    var delegateDeleteData: DelegateDelete?
    @objc func handlePostDelete() {
        
        let text = textForDelete
        let id = idForDelete
        let uid = uidForDelete
        delegateDeleteData?.delete(deleteText: text, deleteId: id, deleteUserUid: uid)
        
        //        let editText: [String] = editingText
//        let editId: [String] = editingId
//
//        delgateEditingData?.editing(editText: editingText, editId: editingId)
//        print("postText PROTOCOL PostSwipe ÄÄÄÄÄ \(editText.count)")
        
    }
    
//    var delegateEndHandle: endPostTextDelegate?
//
//    @objc func endHandlePostText() {
//        delegateEndHandle?.endChangePostText()
//    }
    
    var delegateDelete: PostDeleteDelegate?

    @objc func handleDeletePost() {
        let postId = deletePostId
        let storageId = deleteStorageId

        delegateDelete?.deletePost(postId: postId, storageId: storageId)

    }
    
}

extension PostSwipeCardView: firstCardCheck {
    func cardFirstText(firstText: String, theId: String) {
        actuallyCard.updateValue(theId, forKey: firstText)
        abortProcess()
    }
    
//    func cardFirstText() {
//        abortProcess()
//    }
    
}
