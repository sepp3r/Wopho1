//
//  HastagApi.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 28.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CategoryApi {
    
    var REF_CATEGORY = Database.database().reference().child("category")
    
    static let shared: CategoryApi = CategoryApi()
    private init() {
    }
    
    func fetchPostId(with uid: String, completion: @escaping (String) -> Void) {
        REF_CATEGORY.child(uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            completion(postId)
        }
    }
    
}
