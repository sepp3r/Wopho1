//
//  FeedApi.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 28.12.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    var REF_NEWFEED = Database.database().reference().child("myPosts")
    
    static var shared: FeedApi = FeedApi()
    private init() {
        
    }
    
    func observePostFeed(with uid: String, completion: @escaping (PostModel) -> Void) {
        REF_NEWFEED.child(uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            PostApi.shared.observePost(withPodId: postId) { (post) in
                completion(post)
            }
        }
    }
    
    func observeFeeds(completion: @escaping (PostModel) -> Void) {
        REF_NEWFEED.observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newFeed = PostModel(dictionary: dic, key: snapshot.key)
            completion(newFeed)
        }
    }
    
}
