//
//  PostSwipeCard.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 28.02.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

protocol PostSwipeId {
    func loadPostId(postId: String, coreId: String)
}

protocol buttonLikeDelagate {
    func buttonLike()
}

// Die postID kann gelöscht werden, wird per PostSwipeId übertragen
protocol PostSwipeDelegate {
    func tappedPostCard(userUid: String, postText: String, postId: String)
}

class PostSwipeCard: SwipePostViewCard, UIGestureRecognizerDelegate {
    
    // MARK: - outlet
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet var postBackgroundContainer: UIView!
    
    // MARK: - var / let
    var SearchVCDelegate: SearchPostViewController!
    var likeUnlikeDelegate: buttonLikeDelagate?
    
    // panGesture Test
    var initialCenter = CGPoint()
    
    var zoomIndicator = 1.000
    // Ende
    
    var counterForTapGesture = 0
    
    // zoom overlayout
    var overlay: UIView = {
        let view = UIView(frame: UIScreen.main.bounds);
        view.alpha = 0
        view.backgroundColor = .black
        return view
    }()
    
    // Ende
    
    // Test f. comparsionId
//    var stackContainer: StackContainerPost!
    // Ende
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            setupPostInformation(post: _post)
//            print("post----\(post)")
        }
    }
    
    // MARK: - like var / let
    
    var companyArray = [CompanyUser]()
    var coreDataString = ""
    var savePostId = ""
    var coreDataId = ""
    
    // var test f. saubere reihenfolge bei Like button
    var coreDateTest = ""
    // Ende
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postBackgroundConSetup()
//        stackContainer = StackContainerPost()
//        stackContainer.compareIdDelegate = self
        SearchVCDelegate = SearchPostViewController()
//        print("und__ counter for Tap Gesture \(counterForTapGesture)")
        if counterForTapGesture == 0 {
            let tapGestureCardPost = UITapGestureRecognizer(target: self, action: #selector(handlePostCard))
            postImage.addGestureRecognizer(tapGestureCardPost)
        }
        
//        print("und__ counter 2.0 \(counterForTapGesture)")
        let pinchGesturePostImage = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesturePinch:)))
        postImage.addGestureRecognizer(pinchGesturePostImage)
        pinchGesturePostImage.delegate = self
        
        
        let panGesturePostImage = UIPanGestureRecognizer(target: self, action: #selector(panGestures(gesturePan:)))
        postImage.addGestureRecognizer(panGesturePostImage)
        panGesturePostImage.maximumNumberOfTouches = 2
        panGesturePostImage.minimumNumberOfTouches = 2
        postImage.isUserInteractionEnabled = true
        postImage.isMultipleTouchEnabled = true
        
        if pinchGesturePostImage.numberOfTouches == 2 {
            
            
            print("wie oft kommst du??? 2222 \(pinchGesturePostImage.scale)")
        }
        
        print("wie oft kommst du???\(pinchGesturePostImage.velocity)")
        
        
        // MARK: - TEST for PAN
//        let panGesturePostImage = UIPanGestureRecognizer(target: self, action: #selector(panGestures(gesturePan:)))
//        postImage.addGestureRecognizer(panGesturePostImage)
//        panGesturePostImage.maximumNumberOfTouches = 2
//        panGesturePostImage.minimumNumberOfTouches = 2
        
        
        // pan.delegate nicht
//        panGesturePostImage.delegate = self
        
        
        
        
//        corePostUid()
//        print("handlePostCar !->! \(post?.postText)")
//        loadData()
        
//        print("und__ counter 3.0 \(counterForTapGesture)")
//        likeFunc()
        if let postOfId = post?.postId {
            coreDateTest = postOfId
        }
//        coreDateTest = post?.postId as! String
//        print("und__ counter 4.0 \(counterForTapGesture)")
//        print("test_postText -- \(post?.postText)")
//        coreDateTest.reversed()
//        print("coreDateTest -> !! \(coreDateTest)")
//        print("steck das was drin2222", companyArray.count)
        
//        stackContainer.addGestureRecognizer(tapGestureCardPost)
//        stackContainer.isUserInteractionEnabled = true
       
//        print("funtzt?")
        
        handlePostId()
        
//        postImage.clipsToBounds = true
//        postBackgroundContainer.clipsToBounds = true
//        postBackgroundContainer.translatesAutoresizingMaskIntoConstraints = true
//        print("PostSwipeCard -------- !!!! ------ \(postImage.bounds)")
//        print("PostSwipeCard -------- !!2.0!! ------ \(postBackgroundContainer.bounds)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    // MARK: - TEST von likeButton abgleich
    func tester() {
        coreDateTest = post?.postText! as! String
        
//        for index in post {
//            index.self
//        }
    }
    
    // keine Rückmeldung -> evtl. löschen
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        let tapGestureCardPost = UITapGestureRecognizer(target: self, action: #selector(handlePostCard))
//        postImage.addGestureRecognizer(tapGestureCardPost)
//        postImage.isUserInteractionEnabled = true
//        stackContainer.addGestureRecognizer(tapGestureCardPost)
//        stackContainer.isUserInteractionEnabled = true
//        print("funtzt?")
//    }
    
    func setupPostInformation(post: PostModel) {
//        print("PostSwipeCard", post.postText, post.uid, post.count, post)
        postLabel.text = post.postText
//        savePostId = post.id!
        savePostId = post.postId!
//        coreDateTest = post.postId!
        // test ob loadData() in row 63 funktioniert
//        loadData()
        corePostUid()
        // ende
//        fetchPosts()
//        handlePostId()
//        test()
//        print("PostImage __clipToBounds = True ?????")
//        postImage.clipsToBounds = true
//        postImage.translatesAutoresizingMaskIntoConstraints = true
//        print("beide ID fähig savePostId \(savePostId) &&& coreDataTest \(coreDateTest)")
//        print("postIMAGE DATA -22-- \(postImage.image.debugDescription)")
        guard let url = URL (string: post.imageUrl!) else { return }
        postImage.sd_setImage(with: url) { (_, _, _, _) in
//            print("postIMAGE DATA -11-- \(self.postImage.image.debugDescription)")
            
            
        }
//        print("postImage ===== \(postImage.bounds)")
    }
    
    func postBackgroundConSetup() {
        postBackgroundContainer.layer.cornerRadius = 20
        postBackgroundContainer.backgroundColor = .white
//        postBackgroundContainer.clipsToBounds = true
        postLabel.tintColor = .black
//        postLabel.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
//        postLabel.textColor = UIColor(white: 0.5, alpha: 0.7)
        postLabel.textColor = .black
        postLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    // MARK: - Gesture pan and pinch
    @objc func panGestures(gesturePan: UIPanGestureRecognizer) {
        
        let piece = gesturePan.view!
        let translation = gesturePan.translation(in: piece.superview)
        print("SCAAAAALE test_3....")
        if gesturePan.state == .began {
            self.initialCenter = piece.center
            print("SCAAAAALE test_1....")
        }
        if gesturePan.state == .ended {
            piece.center = initialCenter
            print("SCAAAAALE test_2....")
        } else if gesturePan.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
            print("SCAAAAALE test_3....")
        }
        print(" image")
    }
    
    
    @objc func pinchGesture(gesturePinch: UIPinchGestureRecognizer) {
        
//        if gesturePinch.numberOfTouches == 0 {
//            self.postImage.transform = CGAffineTransform.identity
//            self.postImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//            print("scale ___ scale")
//        }
        
        if gesturePinch.state == .recognized {
            UIView.animate(withDuration: 0.2) {
                self.postImage.transform = CGAffineTransform.identity
                gesturePinch.view?.transform = .identity
            }
        } else if postImage.transform.a >= 1.0 && postImage.transform.d >= 1.0 && postImage.transform.a <= 6.0 && postImage.transform.d <= 6.0 {
            print(" der text 2.0 \(gesturePinch.view)")
            gesturePinch.view?.transform = (gesturePinch.view?.transform.scaledBy(x: gesturePinch.scale, y: gesturePinch.scale))!
            

            gesturePinch.scale = 1.0
            
            
//            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
//                gesturePinch.view?.transform = (gesturePinch.view?.transform.scaledBy(x: gesturePinch.scale, y: gesturePinch.scale))!
//            } completion: { _ in
//                gesturePinch.scale = 1.0
//            }

            
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear, .allowUserInteraction]) {
//
//            } completion: { (finished) in
//
//            }
            
            }
       
        
    }
    
    // Extremer ZOOM beim zweiten mal wenn vorher die Karte bewegt wurde
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        if gestureRecognizer.view != self.postImage {
//            return false
//        }
//
//        if gestureRecognizer.view != otherGestureRecognizer.view {
//            return false
//        }
//
//        if gestureRecognizer is UILongPressGestureRecognizer || otherGestureRecognizer is UILongPressGestureRecognizer {
//            return false
//        }
//
//        return true
//    }
    
//    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
//        postImage.clipsToBounds = false
//        if sender.state == .began || sender.state == .changed {
//            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
//            sender.scale = 1.0
//            print("ZOOOOOM")
//        } else {
//            UIView.animate(withDuration: 0.2) {
//                self.postImage.transform = CGAffineTransform.identity
//                print("Das Ende")
//            }
//        }
//
//
//
//
//    }
    
    
//    @IBAction func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        guard gestureRecognizer.view != nil else { return }
//        let piece = gestureRecognizer.view!
//        let translation = gestureRecognizer.translation(in: piece.superview)
//        if gestureRecognizer.state == .began {
//            self.initialCenter = piece.center
//        }
//
//        if gestureRecognizer.state != .cancelled {
//            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
//            piece.center = newCenter
//        } else {
//            piece.center = initialCenter
//        }
        
        
        
//        let translation = sender.translation(in: postImage)
//
//        guard let gestureView = sender.view else { return }
//
//        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
//
//        sender.setTranslation(.zero, in: postImage)
//
//        if sender.state == .ended {
//            UIView.animate(withDuration: 0.2) {
//                self.postImage.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
//            }
//        }
//
//        guard sender.state == .ended else { return }
        
        
//    }
    
    // MARK: - ImageSetup
//    private func setupImage() {
//        postImage.contentMode = .scaleAspectFill
//        postImage.layer.masksToBounds = true
//    }
    
//    private func setupImageConstraints() {
//        postImage.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([postImage.leadingAnchor.constraint(equalTo: postImage.leadingAnchor), postImage.trailingAnchor.constraint(equalTo: postImage.trailingAnchor), postImage.centerYAnchor.constraint(equalTo: postImage.centerYAnchor), postImage.heightAnchor.constraint(equalToConstant: 250)])
//        postImage.layoutIfNeeded()
//        print("===============&&&&&&bist add Card View ????")
//    }
    
    
    
    // MARK: - like function
    // findet in SearchVC statt -> wird getestet
    func loadData() {
        let companyArray = CoreData.defaults.loadData()
        if let _companyArray = companyArray {
            self.companyArray = _companyArray
        }
    }
    
    func corePostUid() {
        for index in companyArray {
            if index.postUid == post?.postId {
                coreDataId = index.postUid!
//                print("CoreData--> \(coreDataId)")
            }
            
        }
    }
    
    func fetchPosts() {
        for index in companyArray {
//            print("index-> 99999\(index.postUid)")
//            print("CoreData --- \(index.postUid) +++ \(post?.postId)")
            if index.postUid == post?.postId {
//                SearchVCDelegate.likeButton.backgroundColor = .red
//                SearchVCDelegate.test()
//                print("läd ----")
                handlePostId()
                continue
            } else {
//                print("lädt nicht ----")
            }
        }
    }
    
    func saveData() {
//        print("savePostId____\(savePostId)")
        if savePostId.count != 0 {
//            print("savePostId____\(savePostId)")
            let postId = CoreData.defaults.createData(_postUid: savePostId)
        } else {
            errorMess()
        }
    }
    
    func errorMess() {
        let error = UIAlertController(title: "Hinweis", message: "Sammelkarte konnte nicht geladen werden, starte die App erneut!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Bestätigen", style: .default, handler: nil))
        self.SearchVCDelegate.present(error, animated: true, completion: nil)
    }
    
    func deleteCollectCard() {
        for index in companyArray {
            if index.postUid == post?.id {
                let card = index.self
                CoreData.defaults.context.delete(card)
                CoreData.defaults.saveContext()
                continue
            } else {
//                print("else")
            }
        }
    }
    
    func likeFunc() {
        for index in companyArray {
//            print("likeFunc---> \(index.postUid) +++ \(post?.postId)")
            
            if coreDateTest == index.postUid {
                likeUnlikeDelegate?.buttonLike()
                break
            }
        }
//        print("break")
        
    }
    
    func removeTapGesture() {
        counterForTapGesture += 1
    }
    
    
    // MARK: - Show Company Information
    
    var delegatePostId: PostSwipeId?
    
    @objc func handlePostId() {
//        guard let postId = post?.postId else { return }
//        if coreDateTest == coreDataId {
//            let postId = coreDateTest
//            let coreId = coreDataId
//            delegatePostId?.loadPostId(postId: postId, coreId: coreId)
////            print("nochmal ein test____postId\(postId) +++ coreId \(coreId)")
//        }
        
        
        let postId = coreDateTest
        let coreId = coreDataId
        delegatePostId?.loadPostId(postId: postId, coreId: coreId)
        
//        print("coreDataId \(coreDataId)")
//        print("nochmal ein test____postId\(postId) +++coreId \(coreId)")
    }
    
    var delegateHandle: PostSwipeDelegate?
    
    @objc func handlePostCard() {
        guard let userUid = post?.uid else { return }
        guard let postText = post?.postText else { return }
        guard let postId = post?.postId else { return }
        delegateHandle?.tappedPostCard(userUid: userUid, postText: postText, postId: postId)
        
        
//        print("handlePostCar !->! \(postId)")
    }
    
    // MARK: - SearchPost VC -> save the postID
    
}

//extension PostSwipeCard: comparisonID {
//    func compareID() {
//        print("test 2002 !!!!")
//        for index in companyArray {
//            print("likeFunc---> \(index.postUid) +++ \(post?.postId)")
//
//            if index.postUid == post?.postId {
//                likeUnlikeDelegate?.buttonLike()
//                break
//            }
//        }
//    }
//}
