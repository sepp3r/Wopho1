//
//  PostViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 12.10.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Network

protocol firstCardCheck {
    func cardFirstText(firstText: String, theId: String)
}

class PostViewController: UIViewController, SwipeCardDataSource, UIGestureRecognizerDelegate {
    
    
    
    // MARK: - Outlet
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardViewCell: StackContainerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var counterTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bottomOfCardConstraint: NSLayoutConstraint!
    @IBOutlet weak var topOfTheCardConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomOfTheCardConstraint: NSLayoutConstraint!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var toolBarBlurEffect: UIView!
    @IBOutlet weak var activityDeleteIndi: UIActivityIndicatorView!
    @IBOutlet weak var activityResaveIndi: UIActivityIndicatorView!
//    @IBOutlet weak var delStatusLabel: UILabel!
    
    @IBOutlet weak var notInternetView: UIView!
    @IBOutlet weak var notInternetLabel: UILabel!
    @IBOutlet weak var notInternetImage: UIImageView!
    
    @IBOutlet weak var viewOfLastPhoto: UIView!
    
    
//    @IBOutlet weak var tester5000: UIButton!
    
    var user: UserModel? // haben die UserUid in var userUid
    var userUid = ""
    var postId = ""
    var posts = [PostModel]()
    
    var delegatePostText = ""
    var delegatePostId = ""
    var editTestDic: [String : String] = [:]
    
    var nativePostText = ""
    var nativeByPostId = ""
    var nativeTextByCard: [String : String] = [:]
    
    var actuallyPostText = ""
    var cardCheckOfText: firstCardCheck?
    
    weak var testForAbort: PostSwipeCardView?
    
    // Counter for Label
    var counter = 0
    // Ende
    
    var deletePostId = ""
    var deleteStorageId = ""
    var deleteProcessCounter = 0
    var emailForDelete = ""
    var counterForReload = 0
    var redButton = [PostModel]()
    var countRedButton = 0
    // Test weil Array ab 0 zählt und Counter somit nicht richtig läuft
    var totalCounter = 0
//    var totalCounter = -1
    // Ende
    var deleteImageU = ""
    var deleteImageTest = ""
    var deleteId = ""
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var notInternetViewY: CGFloat = 0
    var notInternetDefaultY: CGFloat = 1000
    
    var delegate: SwipeCardDelegate?
    var userDidSet: UserModel? {
        didSet {
            guard let _user = userDidSet else { return }
            setupUserInformation(user: _user)
//            constraintCardCheck()
            print("cardViewCell_________\(cardViewCell.frame)")
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInternet()
        notInternetViewY = notInternetView.frame.origin.y
        notInternetView.frame.origin.y = notInternetDefaultY
        
        print("user Uid \(userUid)")
        setupIndicator()
        loadTheUserMail()
        loadAllMyPosts()
        fillTheEditArry()
        cardViewCell.dataSource = self
        setupView()
        
        cardViewCell.backgroundColor = .clear
        setupBackButton()
//        setupDeleteButton()
        cardViewCell.responeDelegate = self
        cardViewCell.fewCardsDelegate = self
        cardViewCell.swiperDelegate = self
        
        
        let backImage = UIImage(systemName: "chevron.left")
        let leftButtom = UIBarButtonItem(image: backImage, style: UIBarButtonItem.Style.done, target: self, action: #selector(leftBarButtom))
        self.navigationItem.leftBarButtonItem = leftButtom
        
        self.navigationItem.titleView = navigationTitle(text: "App_Name")
        
        
        view .isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        let panEdgeGestureRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanRight(sender:)))
        panEdgeGestureRight.edges = .right
        view.addGestureRecognizer(panEdgeGestureRight)
        
        let panEdgeGestureLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanLeft(sender:)))
        panEdgeGestureLeft.edges = .left
        view.addGestureRecognizer(panEdgeGestureLeft)
//        print("bottom _______constraint --1111-- \(bottomOfCardConstraint.constant)")
    }
    
    override class func awakeFromNib() {
        print("wie wachst du auf----??!?!?!?!?!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Ääääääää--wie wachst du auf----??!?!?!?!?!")
    }
    
    
    
    
    // MARK: - Setup View
    
    func checkInternet() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.yeahConnection()
                }
            } else {
                DispatchQueue.main.async {
                    self.noConnection()
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func yeahConnection() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear) {
            
        } completion: { (_) in
            self.notInternetView.frame.origin.y = -250
            self.notInternetView.isHidden = true
//            self.confirmTrashButton()
//            self.confirmSaveButton()
        }

    }
    
    func noConnection() {
        notInternetView.frame.origin.y = -250
        let notImageOfInternet = UIImage(systemName: "wifi.slash")
        notInternetImage.image = notImageOfInternet
        notInternetImage.tintColor = truqButtonColor
        notInternetLabel.lineBreakMode = .byWordWrapping
        notInternetLabel.textAlignment = .center
        notInternetLabel.text = "Keine Internetverbindung! \nBitte prüfe dein Netzwerk"
        notInternetView.isHidden = false
        disconfrimSaveButton()
        disconfirmTrashButton()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notInternetView.frame.origin.y = self.notInternetViewY
        } completion: { (_) in
            
        }

    }
    
    
    func setupView() {
        notInternetView.layer.cornerRadius = 5
        print("SwipeTest___ Zähler____==4.0= \(counter)")
        disconfrimSaveButton()
        disconfirmAbortButton()
        if notInternetView.isHidden == true {
            confirmTrashButton()
        }
        
        confirmBackButton()
        
        toolBar.layer.cornerRadius = 10
        toolBarBlurEffect.layer.cornerRadius = 10
        
        counterLabel.clipsToBounds = true
        counterLabel.font = UIFont.boldSystemFont(ofSize: 15)
        counterLabel.textColor = truqButtonColor
        counterLabel.layer.cornerRadius = counterLabel.bounds.width / 2
        counterLabel.layer.borderWidth = 2
        counterLabel.tintColor = truqButtonColor
        counterLabel.layer.borderColor = counterLabel.tintColor.cgColor
        counterLabel.backgroundColor = .white
        
        testLabel.clipsToBounds = true
        testLabel.font = UIFont.boldSystemFont(ofSize: 15)
        testLabel.textColor = truqButtonColor
        testLabel.layer.cornerRadius = testLabel.bounds.width / 2
        testLabel.backgroundColor = .white
        testLabel.layer.borderWidth = 2
        testLabel.tintColor = truqButtonColor
        testLabel.layer.borderColor = testLabel.tintColor.cgColor
    }
    
    func confirmBackButton() {
        let backImage = UIImage(systemName: "arrow.uturn.left")
        backButton.setImage(backImage, for: .normal)
        backButton.layer.cornerRadius = backButton.bounds.width/2
        backButton.imageView?.tintColor = truqButtonColor
        backButton.layer.borderWidth = 3
        backButton.tintColor = truqButtonColor
        backButton.layer.borderColor = backButton.tintColor.cgColor
        backButton.backgroundColor = .white
        backButton.isEnabled = true
    }
    
    func disconfirmBackButton() {
        backButton.imageView?.tintColor = darkgrayButtonColor
        backButton.layer.borderWidth = 0
        backButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        backButton.isEnabled = false
    }
    
    func confirmTrashButton() {
        let trashImage = UIImage(systemName: "trash")
        testButton.setImage(trashImage, for: .normal)
        testButton.layer.cornerRadius = testButton.bounds.width/2
        testButton.imageView?.tintColor = darkgrayButtonColor
        testButton.backgroundColor = redColor
        testButton.layer.borderWidth = 2
        testButton.tintColor = darkgrayButtonColor
        testButton.layer.borderColor = testButton.tintColor.cgColor
        testButton.isEnabled = true
    }
    
    func disconfirmTrashButton() {
        let trashImage = UIImage(systemName: "trash")
        testButton.setImage(trashImage, for: .normal)
        testButton.imageView?.tintColor = darkgrayButtonColor
        testButton.layer.borderWidth = 0
        testButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        testButton.isEnabled = false
    }
    
    func confirmAbortButton() {
        abortButton.imageView?.tintColor = truqButtonColor
        abortButton.backgroundColor = .white
        abortButton.layer.borderWidth = 2
        abortButton.tintColor = truqButtonColor
        abortButton.layer.borderColor = abortButton.tintColor.cgColor
        abortButton.isEnabled = true
        
        nativeTextByCard.updateValue(nativePostText, forKey: nativeByPostId)
    }
    
    func disconfirmAbortButton() {
        let abortImage = UIImage(systemName: "xmark")
        abortButton.setImage(abortImage, for: .normal)
        abortButton.clipsToBounds = true
        abortButton.layer.cornerRadius = abortButton.bounds.width/2
        abortButton.imageView?.tintColor = darkgrayButtonColor
        abortButton.layer.borderWidth = 0
        abortButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        abortButton.isEnabled = true
    }
    
    func confirmSaveButton() {
        let saveImage = UIImage(systemName: "paperplane")
        saveButton.setImage(saveImage, for: .normal)
        saveButton.imageView?.tintColor = .white
        saveButton.backgroundColor = truqButtonColor
        saveButton.layer.borderWidth = 3
        saveButton.tintColor = darkgrayButtonColor
        saveButton.layer.borderColor = saveButton.tintColor.cgColor
        saveButton.isEnabled = true
    }
    
    func disconfrimSaveButton() {
        let saveImage = UIImage(systemName: "paperplane")
        saveButton.setImage(saveImage, for: .normal)
        saveButton.layer.cornerRadius = saveButton.bounds.width / 2
        saveButton.imageView?.tintColor = darkgrayButtonColor
        saveButton.layer.borderWidth = 0
        saveButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        saveButton.isEnabled = false
    }
    
    func setupBackButton() {
//        backButton.layer.cornerRadius = backButton.bounds.width / 2
//        backButton.backgroundColor = UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 1.0)
    }
    
//    func setupDeleteButton() {
////        delStatusLabel.isHidden = true
//        testButton.layer.cornerRadius = testButton.bounds.width / 2
//        testButton.backgroundColor = UIColor(red: 205/255, green: 55/255, blue: 0/255, alpha: 1.0)
//        let deleteImage = UIImage(systemName: "trash")
//        testButton.setTitle("", for: .normal)
//        testButton.setImage(deleteImage, for: .normal)
//        testButton.imageView?.tintColor = .black
//        testButton.imageView?.contentMode = .scaleAspectFit
//        testButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
//
//        testButton.isEnabled = true
//    }
    
    func constraintCardCheck() {
        let highOfCardFrame = cardViewCell.frame.height
        
        if highOfCardFrame <= 429 {
            counterTopConstraint.constant = 10
            bottomOfTheCardConstraint.constant = 20
            view.layoutIfNeeded()
        } else if highOfCardFrame <= 468 {
            counterTopConstraint.constant = 40
            view.layoutIfNeeded()
        }
    }
    
    func setupIndicator() {
        activityDeleteIndi.isHidden = true
        activityResaveIndi.isHidden = true
        activityDeleteIndi.stopAnimating()
        activityResaveIndi.stopAnimating()
    }
    
    // MARK: - Keyboard Dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - functions
    
    func backCardFunction() {
        counter += 1
        counterLabel.text = "\(counter)"
        if counter == totalCounter {
            disconfirmBackButton()
        }
    }
    
    func loadAllMyPosts() {
        PostApi.shared.observeMyPost(withUid: userUid) { (postId) in
            PostApi.shared.observePost(withPodId: postId, completion: { (posts) in
                self.posts.insert(posts, at: 0)
                self.redButton.insert(posts, at: 0)
                self.cardViewCell.reloadData()
            })
            
        }
    }
    
    func setupUserInformation(user: UserModel) {
        emailForDelete = user.email!
    }
    
    func loadTheUserMail() {
        UserApi.shared.observeCurrentUser { (currentUser) in
            self.userDidSet = currentUser
        }
    }
    
    func resave() {
//        saveButton.titleLabel?.textAlignment = .center
//        saveButton.setTitle("speichern", for: .normal)
//        saveButton.backgroundColor = UIColor(red: 205/255, green: 173/255, blue: 0/255, alpha: 1.0)
//        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        saveButton.setTitleColor(.black, for: .normal)
//        saveButton.isEnabled = true
    }
    
    func confirmResave() {
        activityResaveIndi.isHidden = true
        activityResaveIndi.stopAnimating()
        
        let checkmarkImage = UIImage(systemName: "checkmark")
        saveButton.setImage(checkmarkImage, for: .normal)
        saveButton.imageView?.tintColor = .white
        
//        saveButton.titleLabel?.textAlignment = .center
//        saveButton.setTitle("gespeichert", for: .normal)
//        saveButton.backgroundColor = .white
//        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        saveButton.isEnabled = false
        editTestDic.updateValue(delegatePostText, forKey: delegatePostId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.disconfrimSaveButton()
            self.disconfirmAbortButton()
        }
        
        
    }
    
    func fillTheEditArry() {
        if countRedButton != 0 {
            for data in posts {
                guard let postText = data.postText else { return }
                guard let postId = data.postId else { return }
                
            }
        }
    }
    
    func confirmDelete() {
        print("#1")
        activityDeleteIndi.isHidden = true
        activityDeleteIndi.stopAnimating()
        let checkmarkImage = UIImage(systemName: "checkmark")
        testButton.setImage(checkmarkImage, for: .normal)
        testButton.imageView?.tintColor = darkgrayButtonColor
        testButton.isEnabled = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.confirmTrashButton()
            if self.countRedButton != 0 {
//                self.confirmTrashButton()
                print("test für Trashbutton ----- CONFIRM")
            } else {
//                self.disconfirmTrashButton()
                print("test für Trashbutton ----- disCONFIRM")
            }
        }
        
        
//        testButton.isEnabled = true
        print("[func confirmDelete 1.0]--countRedButton \(countRedButton) != \(totalCounter)")
        let buttonDelete = redButton[countRedButton]
        deleteId = buttonDelete.postId!
        deleteImageU = buttonDelete.storagePostId!

        let stopover = countRedButton
        
        print("stopover count -----> \(stopover)")
        
        posts.remove(at: countRedButton)
        redButton.remove(at: countRedButton)
        
        
        
        if countRedButton == -1 {
            countRedButton = 0
        }
//        if totalCounter <= 3 {
//            totalCounter -= 1
//            testLabel.text = "\(totalCounter)"
//        }
        totalCounter -= 1
        testLabel.text = "\(totalCounter)"
        
        
        
        print("[func confirmDelete 2.0]--countRedButton \(countRedButton) != \(totalCounter)")
        
        if countRedButton != totalCounter {
//            let deleteImage = UIImage(systemName: "trash")
//            testButton.setTitle("", for: .normal)
//            testButton.setImage(deleteImage, for: .normal)
//            testButton.imageView?.tintColor = .black
//            testButton.imageView?.contentMode = .scaleAspectFit
//            testButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
            
            for index in redButton {
                print("array normal \(index.postText)")
            }
            
            for i in redButton.reversed() {
                print("array reversed \(i.postText)")
            }
            
            
            
            let delete = redButton[countRedButton]
            deleteId = delete.postId!
            deleteImageU = delete.storagePostId!
            print("confirmDelete -- deleteId->\(deleteId) +++ deleteImageU->\(deleteImageU)")
        } else {
//            testButton.isEnabled = false
//            testButton.backgroundColor = .gray
            disconfirmTrashButton()
        }
        self.cardViewCell.deleteTheFirstCard()
        if counterForReload <= 1 {
            counterForReload += 1
        }
    }
    
    func errorResave() {
        activityResaveIndi.isHidden = true
        activityResaveIndi.stopAnimating()
        saveButton.backgroundColor = redColor
        saveButton.tintColor = darkgrayButtonColor
        saveButton.titleLabel?.lineBreakMode = .byWordWrapping
        saveButton.titleLabel?.textAlignment = .center
        saveButton.setTitle("Fehler", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
        saveButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            self.disconfrimSaveButton()
            self.disconfirmAbortButton()
        }
    }
    
    func errorDelete() {
        activityDeleteIndi.isHidden = true
        activityDeleteIndi.stopAnimating()
        let xmarkImage = UIImage(systemName: "xmark")
        testButton.setImage(xmarkImage, for: .normal)
        testButton.imageView?.tintColor = darkgrayButtonColor
        testButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.confirmTrashButton()
        }
//        testButton.setImage(nil, for: .normal)
//        delStatusLabel.isHidden = false
//        delStatusLabel.tintColor = .black
//        delStatusLabel.text = "fehler"
//        delStatusLabel.font = UIFont.boldSystemFont(ofSize: 13)
//        delStatusLabel.backgroundColor = .clear
//        testButton.isEnabled = false
    }
    
    // MARK: - Navigation unwind
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindMyPost" {
            let unwindToMyPostVC = segue.destination as! MyPostViewController
            if counterForReload != 0 {
                unwindToMyPostVC.counterOfView = self.counterForReload
                counterForReload = 0
            }
        }
    }
    
    // MARK: - Save & delete functions
    func uploadPostTextData() {
        saveButton.setTitle("", for: .normal)
        saveButton.setImage(nil, for: .normal)
        activityResaveIndi.startAnimating()
        activityResaveIndi.isHidden = false
        AuthenticationService.updatePostLabelText(postId: delegatePostId, postText: delegatePostText, onSuccess: {
            self.confirmResave()
        }) { (errorMessage) in
            self.errorResave()
        }
    }
    
    
    func deletePostData() {
        testButton.setTitle("", for: .normal)
        testButton.setImage(nil, for: .normal)
        activityDeleteIndi.startAnimating()
        activityDeleteIndi.isHidden = false
        AuthenticationService.deletePost(postId: deleteId, ImageUrl: deleteImageU, email: emailForDelete, onSuccess: {
            if self.deleteProcessCounter >= 1 {
                self.confirmDelete()
                self.deleteProcessCounter -= 1
            }
        }) { (errorMessage) in
            self.errorDelete()
            self.deleteProcessCounter -= 1
        }
 
    }
    
    func deleteTheFirtCard() {
        if countRedButton == 0 {
            let buttonDeleteFirst = redButton[countRedButton]
            deleteId = buttonDeleteFirst.postId!
            deleteImageU = buttonDeleteFirst.storagePostId!
        }
    }
    
    func deleteTheCard() {
        if countRedButton >= totalCounter {
            testButton.isEnabled = false
            testButton.backgroundColor = .gray
        } else if countRedButton != posts.count {
//            let buttonDelete = redButton[countRedButton]
//            deleteImageU = buttonDelete.imageUrl!
//            deleteId = buttonDelete.postId!
        }
    }
    
    func backCardByDelete() {
        if countRedButton != 0 {
            countRedButton -= 1
//            testButton.backgroundColor = UIColor(red: 205/255, green: 55/255, blue: 0/255, alpha: 1.0)
//            testButton.isEnabled = true
//            disconfirmTrashButton()
            if notInternetView.isHidden == true {
                confirmTrashButton()
            }
            let backRedButtonDelete = redButton[countRedButton]
            deleteId = backRedButtonDelete.postId!
            deleteImageU = backRedButtonDelete.storagePostId!
        } else if countRedButton == 0 {
            disconfirmTrashButton()
        }
    }
    
    func delete() {
        countRedButton += 1
        print("[func delete]--countRedButton \(countRedButton) != \(totalCounter)")
        print("[func delete] 2.0 -- deleteId->\(deleteId) +++ deleteImageU->\(deleteImageU)")
        if countRedButton != totalCounter {
//            setupDeleteButton()
            let deletePost = redButton[countRedButton]
            deleteId = deletePost.postId!
            deleteImageU = deletePost.storagePostId!
        } else {
            disconfirmTrashButton()
        }
        print("[func delete] 3.0 -- deleteId->\(deleteId) +++ deleteImageU->\(deleteImageU)")
    }
    
    // MARK: - Screen Edge Pan Gesture
    @objc func edgePanRight(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            backCardByDelete()
            cardViewCell.backCard()
            backCardFunction()
        }
    }
    
    @objc func edgePanLeft(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            backCardByDelete()
            cardViewCell.backCard()
            backCardFunction()
        }
    }
    
    // MARK: - Navigation Bar Setup
    
    func navigationTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        
        let tapGestureNaviTitle = UITapGestureRecognizer(target: self, action: #selector(titleUnwind))
        label.addGestureRecognizer(tapGestureNaviTitle)
        label.isUserInteractionEnabled = true
        
        return label
    }
    
    @objc func titleUnwind() {
        performSegue(withIdentifier: "titleUnwind", sender: self)
    }
    
    @objc func leftBarButtom() {
        performSegue(withIdentifier: "unwindMyPost", sender: self)
    }
    
    // MARK: - Action
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if delegatePostText != "" && delegatePostId != "" {
            uploadPostTextData()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        backCardByDelete()
        cardViewCell.backCard()
        backCardFunction()
//        counter += 1
//        counterLabel.text = "\(counter)"
//        if counter == totalCounter {
//            disconfirmBackButton()
//        }
    }
    
    
    @IBAction func testButtonTapped(_ sender: UIButton) {
        deleteProcessCounter += 1
        counter -= 1
        counterLabel.text = "\(counter)"
        deletePostData()
        
        print("Lösch_____Test -- deleteId->\(deleteId) +++ deleteImageU->\(deleteImageU)")
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
//        print("ist das der ursprüngliche Text \(actuallyPostText)")
//        cardCheckOfText?.cardFirstText()
        
        
//        nativeTextByCard.updateValue(nativePostText, forKey: nativeByPostId)
        
        
//      cardCheckOfText?.cardFirstText(firstText: nativePostText, theId: nativeByPostId)
        
        cardViewCell.refreshData()
        disconfrimSaveButton()
        disconfirmAbortButton()
//        cardViewCell.reloadData()
    }
    
}

extension PostViewController {
    
    func numberOfCardToShow() -> Int {
        testLabel.text = "\(posts.count)"
        if totalCounter != posts.count {
            counterLabel.text = "\(posts.count)"
            print("backButton zähler \(counter) &&& total \(totalCounter)")
            if counter == totalCounter {
                disconfirmBackButton()
            }
        }
        
        totalCounter = posts.count
        
        
        
        print("SwipeTest___ Warum ist der COUNTER nUll ?????? \(counter)")
        
        return posts.count
    }
    
    func card(forItemAtIndex index: Int) -> PostSwipeCardView {
        let card = PostSwipeCardView()
        deleteTheFirtCard()
        
        
        print("cardPost Info __S__Count \(posts.count)")
        card.post = posts[index]
        print("cardPost Info __S__ \(card.post.debugDescription)")
        card.postData = posts
        card.backAgainDic = editTestDic
        card.actuallyCard = nativeTextByCard
        card.delegateHandle = self
        card.delegateNativePost = self
        card.backBack = self
//        card.cardCheckOfText = self
//        card.delegateDeleteData = self
//        card.postLabel.text = actuallyPostText
        
//        print("frame ----- \(cardViewCell.frame)")
//
//        print("Lösch__card___Test -- deleteId->\(card.post!.postId) +++ deleteImageU->\(card.post!.storagePostId) +++++ deleteText->\(card.post!.postText)")
        constraintCardCheck()
        return card
    }
    
    
    func emptyView() -> UIView? {
        return nil
    }
}

extension PostViewController: PostTextDelegate {
    
    func changePostText(postId: String, postText: String) {
        self.delegatePostId = postId
        self.delegatePostText = postText
//        resave()
        if notInternetView.isHidden == true {
            confirmSaveButton()
        }
        
        confirmAbortButton()
    }
}

extension PostViewController: NativePostTextDelegate {
    func nativePosts(nativePostId: String, nativeText: String) {
        self.nativePostText = nativeText
        self.nativeByPostId = nativePostId
//        print("teeeest funktoniert---- 1111 third____\(self.nativePostText) &&& Post Id ______ \(nativeByPostId)")
    }
}

//extension PostViewController: DelegateDelete {
//    func editing(editText: [String], editId: [String]) {
//    }
//}

extension PostViewController: DelegateDelete {
    func delete(deleteText: String, deleteId: String, deleteUserUid: String) {
//        print("ist das der ursprüngliche Text \(deleteText)")
        actuallyPostText = deleteText
    }
    
    
}

// Kann gelöscht werden????
extension PostViewController: PostDeleteDelegate {

    func deletePost(postId: String, storageId: String) {
        self.deletePostId = postId
        self.deleteStorageId = storageId
        self.deleteImageTest = storageId
    }
}
// Ende

extension PostViewController: cardRespone {
    func respon() {
//        print("respon_____________PostViewController_______________")
//        setupView()
//        setupDeleteButton()
//        deleteTheCard()
    }
}

// wenn second delete funktioniert dann löschen
extension PostViewController: cardCheck {
    func fewCards() {
//        print("geht dsa -- \(countRedButton)")
//        for index in redButton {
//            print("#few---postID \(postId) ++++ URL \(index.storagePostId)")
//            print("#few geht dsa in For Schleife")
//        }
//
//        if redButton.count != 0 {
//            print("#fewCountRedButton \(countRedButton)")
//            let buttonDelete = redButton[countRedButton]
//            deleteImageU = buttonDelete.storagePostId!
//            deleteId = buttonDelete.postId!
//            print("#fewCards --URL \(deleteImageU) &&&& postID -- \(deleteId)")
//        }
//
//
//        for index in redButton {
////            print("#fewCards---redButtonIndex \(index.postId) && URL \(index.imageUrl)")
//
//            print("#fewCards---redButtonID -- \(index.postId)")
//        }
//
//        for i in posts {
////            print("#fewCards---- postIndex \(i.postId) && URL \(i.imageUrl)")
//
//            print("#fewCards---postsID -- \(i.postId)")
//        }
//
//        if totalCounter != 0 {
//           totalCounter -= 1
//        }
        
    }
}

extension PostViewController: swipeIndex {
    func swipe() {
        print("SwipeTest___ swiperCount RED Button \(countRedButton)")
        print("SwipeTest___ TOTAL Counter \(totalCounter)")
        
        let secondCounter = counter
        print("SwipeTest___ Zähler____==2.0= \(counter)")
        
        if secondCounter != 0 {
            counter -= 1
        } else {
            counter = totalCounter - 1
        }
        print("SwipeTest___ Zähler____==3.0= \(counter)")
        counterLabel.text = "\(counter)"
        delete()
        setupView()
        if counter == 0 {
            disconfirmTrashButton()
        }
        print("Swipe löscht den editText--------!!!------")
////        if countRedButton == 0 {
////            countRedButton += 2
////        } else {
////            countRedButton += 1
////        }
//
//        for index in redButton {
////            print("#fewCards---redButtonIndex \(index.postId) && URL \(index.imageUrl)")
//
//            print("#swipe---redButtonID -- \(index.postId)")
//        }
//
//        for i in posts {
////            print("#fewCards---- postIndex \(i.postId) && URL \(i.imageUrl)")
//
//            print("#swipe---postsID -- \(i.postId)")
//        }
//
//        print("swipe -1-1- totalCounter \(totalCounter) &&&& countRedButton \(countRedButton)")
//
////        switch totalCounter - countRedButton {
////        case 2:
////            countRedButton += 2
////        default:
////            countRedButton += 1
////        }
//        countRedButton += 1
//        print("swipe -2-2- countRedButton \(countRedButton) 6666 totalCounter \(totalCounter)")
    }
}
