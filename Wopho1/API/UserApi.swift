//
//  UserApi.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 15.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    
    static var shared: UserApi = UserApi()
    private init() {
    }
    
    // Aktuell eingeloggte User ID
    var CURRENT_USER_UID: String? {
        if let currentUserUid = Auth.auth().currentUser?.uid {
            return currentUserUid
        }
        return nil
    }
    
    // Aktuell eingeloggte User
    var CURRENT_USER: User? {
        if let currenUserUid = Auth.auth().currentUser {
            return currenUserUid
        }
        return nil
    }
    
    // MARK: - Load all users
    func observeUsers(completion: @escaping (UserModel) -> Void) {
        REF_USERS.observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newUsers = UserModel(dictionary: dic)
            completion(newUsers)
        }
    }
    
    
    
        
    // Lade den User mit der Id
    func observeUser(uid: String, completion: @escaping (UserModel) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newUser = UserModel(dictionary: dic)
            completion(newUser)
        }
    }
    
    // Lade den aktullen User
    func observeCurrentUser(completion: @escaping (UserModel) -> Void ) {
        guard let currentUser = CURRENT_USER_UID else { return }
        REF_USERS.child(currentUser).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let currentUser = UserModel(dictionary: dic)
            completion(currentUser)
        }
        
    }
    
    // Search User
    
    func queryUser(withText text: String, completion: @escaping(UserModel) -> Void) {
        REF_USERS.queryOrdered(byChild: "username").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach { (data) in
                let child = data as! DataSnapshot
                guard let dic = child.value as? [String: Any] else { return }
                let user = UserModel(dictionary: dic)
                completion(user)
            }
        }
    }


}
