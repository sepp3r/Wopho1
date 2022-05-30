//
//  CategoryViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 25.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var likeCountlabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - var / let
    
    var posts = [PostModel]()
    var post: PostModel?
    //var category = "category"
    
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupUserInformation(user: _user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchCurrentUser()
        setupCompanyImage()
        //loadMyPosts()
        //loadPost(category: category)
        loadMyCategories()
        loadmyPost()
    }
    
    // MARK: - load myCategories
    func loadMyCategories() {
//        print("_____Kategorie__1___")
        guard let currendUserUid = UserApi.shared.CURRENT_USER_UID else { return }
//        print("_____Kategorie__2___")
//        print(currendUserUid)
        PostApi.shared.observeMyPost(withUid: currendUserUid) { (postId) in
//            print(postId)
//            print("_____Kategorie__3___")
            PostApi.shared.observePost(withPodId: postId, completion: { (post) in
//                print("_____Kategorie__4___")
                self.posts.insert(post, at: 0)
                self.tableView.reloadData()
//                print("_____Kategorie__5___")
            })
        }
    }
    
    func loadmyPost() {
        guard let currenUserUid = UserApi.shared.CURRENT_USER_UID else { return }
        PostApi.shared.observeMyPost(withUid: currenUserUid) { (postId) in
            PostApi.shared.observePost(withPodId: postId, completion: { (post) in
                self.posts.insert(post, at: 0)
                self.tableView.reloadData()
            })
        }
    }
    
//    func loadMyPosts() {
//        //guard let currentUserUid = UserApi.shared.CURRENT_USER_UID else { return }
//        CategoryApi.shared.fetchPostId(with: userUid) { (postId) in
//            PostApi.shared.observePost(withPodId: postId, completion: { (post) in
//                self.posts.insert(post, at: 0)
//                self.tableView.reloadData()
//                print("_____MY Post_____")
//            })
//        }
//    }
    
//    func loadPost(category: String) {
//        CategoryApi.shared.fetchPostId(with: category) { (postId) in
//            PostApi.shared.observePost(withPodId: postId, completion: { (post) in
//                self.posts.insert(post, at: 0)
//                self.tableView.reloadData()
//            })
//        }
//    }
    
    // User Information
    func setupUserInformation(user: UserModel) {
        guard let url = URL(string: user.companyImageUrl!) else { return }
        companyImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
        print("_____USER-Info_____")
    }
    
    func fetchCurrentUser() {
        UserApi.shared.observeCurrentUser { (currentUser) in
            self.user = currentUser
        }
        print("_____CURRENT USER_____")
    }
    
    // Setup View
    
    func setupCompanyImage() {
        companyImageView.layer.cornerRadius = companyImageView.bounds.height/2
    }

}
    



extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        //return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        //cell.categoryNameLabel?.text = "Test"
        
        cell.post = posts[indexPath.row]
        
        
        return cell
    }



}
