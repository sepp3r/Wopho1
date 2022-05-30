//
//  MyPostViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 07.10.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import Network

class MyPostViewController: UIViewController {

    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notInternetView: UIView!
    @IBOutlet weak var notInternetLabel: UILabel!
    @IBOutlet weak var notInternetImage: UIImageView!
    
    
    // MARK: - var / let
    var user: UserModel?
    var posts = [PostModel]()
    var userUid = ""
    var postId = ""
    
    var tester2000 = ""
    
    var counterOfView = 0
    
    var notInternetViewY: CGFloat = 0
    var notInternetDefaultY: CGFloat = 1000
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    let postVCDelegate = PostViewController()
//    var postVCDelegate: PostViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notInternetView.layer.cornerRadius = 5
        checkInternet()
        notInternetViewY = notInternetView.frame.origin.y
        notInternetView.frame.origin.y = notInternetDefaultY
        print("was das los2222", posts.count)
        
        collectionView.backgroundColor = UIColor.init(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchCurrentUser()
        loadMyPosts()
//        naviBarImage()
        
//        print("tester 2000 ???? \(tester2000)")
//
//        print("current counterOfView", counterOfView)
        
        self.navigationItem.titleView = navigationTitleMyPost(text: "App_Name")
                
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }

//     funktioniert zwar aber doppelter download der posts
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear Counter 1.0", counterOfView)
        if counterOfView == 1 {
//            posts.removeAll()
//            collectionView.reloadData()
            counterOfView -= 1
            print("viewWillAppear Counter 1.1", counterOfView)
        }
//        if isMovingFromParent == true {
//            print("test 1234")
//        }
        
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        print("Wann funktionierst du eigentlich !!---!!")
//        posts.removeAll()
//        viewDidLoad()
//    }
    
    // MARK: - Functions
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
        }

    }
    
    func noConnection() {
        notInternetView.frame.origin.y = -250
        notInternetImage.image = UIImage(systemName: "wifi.slash")
        notInternetImage.tintColor = truqButtonColor
        notInternetLabel.lineBreakMode = .byWordWrapping
        notInternetLabel.textAlignment = .center
        notInternetLabel.text = "Keine Internetverbindung! \nBitte prüfe dein Netzwerk"
        notInternetView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notInternetView.frame.origin.y = self.notInternetViewY
        } completion: { (_) in
            
        }

    }
    
    func naviBarImage() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "project1")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    // MARK: - Fetch Current User
    func fetchCurrentUser() {
        UserApi.shared.observeCurrentUser { (currentUser) in
//            print("aktueller currentUser!?!?!?!?", currentUser.)
            self.user = currentUser
            print("MyPostVC -- current User \(self.user)")
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Load My Posts
    func loadMyPosts() {
        guard let currentUserUid = UserApi.shared.CURRENT_USER_UID else { return }
        PostApi.shared.observeMyPost(withUid: currentUserUid) { (postId) in
            PostApi.shared.observePost(withPodId: postId, completion: { (post) in
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyPostToPostVC" {
            let postUserInfoVC = segue.destination as! PostViewController
            postUserInfoVC.userUid = self.userUid
            postUserInfoVC.postId = self.postId
//            let controller = (segue.destination as! UINavigationController).topViewController as! PostViewController
//            controller.navigationItem = object
//            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    func navigationTitleMyPost(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        
        let tapGestureNaviTitle = UITapGestureRecognizer(target: self, action: #selector(titleUnwindMyPostVC))
        label.addGestureRecognizer(tapGestureNaviTitle)
        label.isUserInteractionEnabled = true
        
        return label
    }
    
    @objc func titleUnwindMyPostVC() {
        performSegue(withIdentifier: "titleUnwindMyPostVC", sender: self)
    }
    
    @IBAction func unwindToMyPostVC(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        if counterOfView != 0 {
            posts.removeAll()
            viewDidLoad()
            counterOfView = 0
        }
    }
    
    
}

extension MyPostViewController: PostCellDelegate {
    func tappedPost(userUid: String, postId: String) {
        self.userUid = userUid
        self.postId = postId
        performSegue(withIdentifier: "MyPostToPostVC", sender: self)
//        counterOfView += 1
        print("segue counterOfView", counterOfView)
    }
}


// MARK: - CollectionView Datasource
extension MyPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostImageCollectionViewCell", for: indexPath) as! MyPostImageCollectionViewCell
        
        cell.post = posts[indexPath.row]
        cell.delegate = self
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyPostHeaderCollectionViewCell", for: indexPath) as! MyPostHeaderCollectionViewCell
        
        if let user = self.user {
            cell.user = user
            cell.postCountLabel.text = "\(posts.count)"
        }
        return cell
    }
}


// MARK: - CollectionView FlowLayout
extension MyPostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2.19 - 1
        let height: CGFloat = collectionView.frame.height / 3.05 - 1
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
