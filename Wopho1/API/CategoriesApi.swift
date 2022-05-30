//
//  categoriesApi.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.10.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CategoriesApi {
    
    var REF_CATEGORIES = Database.database().reference().child("categories")
    var REF_MY_CATEGORIES = Database.database().reference().child("mycategories")
    var REF_MY_CATEGORIESES = Database.database().reference().child("mycategories").child(" ")
    
    static var shared: CategoriesApi = CategoriesApi()
    private init() {
    }
    
    func fetchUserId(with userId: String, completion: @escaping (String) -> Void) {
        REF_MY_CATEGORIES.child(userId)
    }
    
    func observeMyCategory(withUid uid: String, completion: @escaping (String) -> Void) {
        REF_MY_CATEGORIES.child(" ").child(uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            completion(postId)
        }
    }
    
}
