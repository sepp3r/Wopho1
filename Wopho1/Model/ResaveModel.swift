//
//  ResaveModel.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 13.09.20.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation

class ResaveModel: NSObject, Codable {
    
//    var categoriesText: String?
//    var uid: String?
//    
//    init(dictionary: [String: Any]) {
//        categoriesText = dictionary["categoriesText"] as? String
//        uid = dictionary["uid"] as? String
//    }
    
    var resaveText: String?
    var resaveId: String?
    
    init(dictionary: [String: Any], key: String) {
        resaveText = dictionary["resaveText"] as? String
        resaveId = dictionary["resaveId"] as? String
    }
    
}
