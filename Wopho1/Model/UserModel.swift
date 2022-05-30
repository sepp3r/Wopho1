//
//  UserModel.swift
//  PiCCO
//
//  Created by Sebastian Schmitt on 13.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation

class UserModel {
    
    enum ExpressionKey: String {
        case username
    }
    
    var username: String?
    var email: String?
    var companyImageUrl: String?
    var countryCode: String?
    var street: String?
    var city: String?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    var radius: Double?
    var phone: String?
    var mobilePhone: String?
    var homepage: String?
    var uid: String?
    var textForEverything: String?
    var payment: Bool?
    var amount: Double?
    
    init(dictionary: [String: Any]) {
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
        companyImageUrl = dictionary["companyImageUrl"] as? String
        countryCode = dictionary["countryCode"] as? String
        street = dictionary["street"] as? String
        city = dictionary["city"] as? String
        country = dictionary["country"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        radius = dictionary["radius"] as? Double
        phone = dictionary["phone"] as? String
        mobilePhone = dictionary["mobilePhone"] as? String
        homepage = dictionary["homepage"] as? String
        uid = dictionary["uid"] as? String
        textForEverything = dictionary["textForEverything"] as? String
        payment = dictionary["payment"] as? Bool
        amount = dictionary["amount"] as? Double
    }
}
