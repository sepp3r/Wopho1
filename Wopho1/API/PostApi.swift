//
//  Post.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 26.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    var REF_MY_POSTS = Database.database().reference().child("myposts")
    var REF_DEL_MY_POST = Database.database().reference().child("myposts")
    
    static var shared: PostApi = PostApi()
    private init() {
    }
    
    // MARK: - Load all posts
    func observePosts(completion: @escaping (PostModel) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newPost = PostModel(dictionary: dic, key: snapshot.key)
            completion(newPost)
        }
    }
    
    func fetchALimitOfPosts(completion: @escaping (PostModel) -> Void) {
        REF_POSTS.queryLimited(toFirst: 25).observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String : Any] else { return }
            let newPost = PostModel(dictionary: dic, key: snapshot.key)
            completion(newPost)
        }
        
        
        
//        REF_POSTS.queryStarting(afterValue: 25).observe(.childAdded) { (snapshot) in
//            guard let dic = snapshot.value as? [String : Any] else { return }
//            let newPost = PostModel(dictionary: dic, key: snapshot.key)
//            completion(newPost)
//        }
    }
    
    // MARK: - Timestamp load
    func timestampTest(time timestamp: Double, completion: @escaping (PostModel) -> Void) {
//        let testtimestamp: Double = 1635880499.308532
        REF_POSTS.queryOrdered(byChild: "postTime").queryStarting(afterValue: timestamp).queryLimited(toFirst: 3).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach { (data) in
                let child = data as! DataSnapshot
                guard let dic = child.value as? [String: Any] else { return }
                let newPost = PostModel(dictionary: dic, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    
    // MARK: - Load post count
    func fetchPostCount(withUid uid: String, completion: @escaping(UInt) -> Void) {
        REF_MY_POSTS.child(uid).observe(.value) { (snapshot) in
            let postCount = snapshot.childrenCount
            completion(postCount)
        }
    }
    
//    func fetchPostsCount(withId postId: String, completion: @escaping(UInt) -> Void) {
//        REF_POSTS.child(postId).observe(.value) { (snapshot) in
//            let postCount = snapshot.childrenCount
//            completion(postCount)
//        }
//    }
    
//    // Postcount by Usersearch = test V1.0
//    func fetchSearchPostCount(withId id: String, completion: @escaping(UInt) -> Void) {
//        REF_POSTS.observe(.value, with: { snapshot in
//            let searchCount = snapshot.childrenCount
//            completion(searchCount)
//            print("searchCountTest","\(id)")
//            print("searchCountTest","\(snapshot)")
//        })
//    }
    
    // test V1.1
//    func testPostCountSearch(withUid uid: String, completion: @escaping(UInt) -> Void) {
//        REF_POSTS.observe(.value) { (snapshot) in
//            let testCount = snapshot.childrenCount
//            completion(testCount)
//            print("testTwoAPI--------->1","\(uid)")
//            print("testTwoAPI--------->2","\(snapshot)")
//            print("testTwoAPI--------->3","\(snapshot.childrenCount)")
//            print("testTwoAPI--------->4","\(testCount)")
//        }
//    }
    
    // Download for Wishlist and Note for snapshot null
    func observePostforWishList(withPodId id: String, completion: @escaping(PostModel, String) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            var _null: String = ""
            var dic: [String : Any] = [:]
            if snapshot.value is NSNull {
                _null = snapshot.key
            } else {
                dic = (snapshot.value as? [String : Any])!
            }
            let newPost = PostModel(dictionary: dic, key: snapshot.key)
            completion(newPost, _null)
        }
    }
    
    
    // Download every single Post
    func observePost(withPodId id: String, completion: @escaping(PostModel) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newPost = PostModel(dictionary: dic, key: snapshot.key)
            completion(newPost)
        }
    }
    
    // SearchPost with Company or UserUid -> testen von 27.10.20
//    func downloadUserUid(withUserUid uid: String, completion: @escaping(PostModel) -> Void) {
//        REF_POSTS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            print("---API-Post---Test")
//            guard let dic = snapshot.value as? [String: Any] else { return }
//            print("testThree----->1.5",snapshot)
//            let uid = PostModel(dictionary: dic, key: snapshot.key)
//            completion(uid)
//        }
//    }
    
    // my Search post
    func observeSearchPost(withText postText: String, completion: @escaping(PostModel) -> Void) {
        REF_POSTS.child(postText).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let searchPost = PostModel(dictionary: dic, key: snapshot.key)
            completion(searchPost)
        }
    }
    
    // my Posts laden 2.0
    func observeMyPost(withUid uid: String, completion: @escaping (String) -> Void) {
        REF_MY_POSTS.child(uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            completion(postId)
        }
    }
    
    // delete my Post with Id
    func deleteMyPost(withUid uid: String, completion: @escaping(PostModel) -> Void) {
        REF_DEL_MY_POST.child(uid).observe(.value) { (snapshot) in
            if let posts = snapshot.value as? [String: AnyObject] {
            }
        }
    }
    
    // Post Search Limited
    func queryPost(withText text: String, completion: @escaping(PostModel) -> Void) {
        REF_POSTS.queryOrdered(byChild: "postText").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach { (data) in
                let child = data as! DataSnapshot
                guard let dic = child.value as? [String: Any] else { return }
                let post = PostModel(dictionary: dic, key: snapshot.key)
                completion(post)
            }
        }
    }
    
    // ob eine zweite query Post gebraucht wird
//    func secondQueryPost(withText text: String, completion: @escaping(PostModel) -> Void) {
//        REF_POSTS.queryOrdered(byChild: "postText").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
//            snapshot.children.forEach { (data) in
//                let child = data as! DataSnapshot
//                guard let dic = child.value as? [String: Any] else { return }
//                let post = PostModel(dictionary: dic, key: snapshot.key)
//                completion(post)
//            }
//        }
//    }
    
    // Post Search All Posts
    func queryAllPost(withText text: String, completion: @escaping(PostModel) -> Void) {
        REF_POSTS.queryOrdered(byChild: "postText").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach { (data) in
                let child = data as! DataSnapshot
                guard let dic = child.value as? [String: Any] else { return }
                let post = PostModel(dictionary: dic, key: snapshot.key)
                completion(post)
            }
            
        }
    }
    
    // Post Serch with Company or UserUid
    
    
    // MARK: - PostLabel update -> resave PostText
//    func updatePostText(postText: String, onSuccess: @escaping () -> Void) {
//        
//        
//        let dic = ["postText" : postText]
//        
//    }
    
}

