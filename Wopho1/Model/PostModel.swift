//
//  Post.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 26.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation

class PostModel: NSObject, Codable {
    
    
//    enum ExpressionKey: String {
//        case postText
//    }
    
    var postText: String?
    var imageUrl: String?
    var uid: String?
    var id: String?
    var count: String?
    var postId: String?
    var storagePostId : String?
    var secondsFrom1970: Double?
    var postDate: Date?
    
    init(dictionary: [String: Any], key: String) {
        postText = dictionary["postText"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        uid = dictionary["uid"] as? String
        id = key
        postId = dictionary["postId"] as? String
        count = dictionary["count"] as? String
        storagePostId = dictionary["storagePostId"] as? String
        secondsFrom1970 = dictionary["postTime"] as? Double
        if let _secondsFrom1970 = secondsFrom1970 {
            postDate = Date(timeIntervalSince1970: _secondsFrom1970)
        }
        
    }
}
