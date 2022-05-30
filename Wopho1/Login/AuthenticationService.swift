//
//  AuthenticationService.swift
//  PiCCO
//
//  Created by Sebastian Schmitt on 22.07.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Keychains

class AuthenticationService {
    
    // MARK: - Loginto
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            print(data?.user.email ?? "")
            print(data?.user.uid ?? "")
            onSuccess() // Der übergebene Closure wird beim erfolgreichen einloggen ausgeführt
            
        }
    }
    
    // MARK: - Autologin
    static func automaticSingIn(onSuccess: @escaping () -> Void) {
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                    onSuccess()
                })
            }
        }
    }
    
    static func automaticSingInto(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        if Auth.auth().currentUser != nil {
//            DispatchQueue.main.async {
//                Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { (timer) in
//                    onSuccess()
//                })
//            }
            onSuccess()
        } else if Auth.auth().currentUser == nil {
//            DispatchQueue.main.async {
//                Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { (timer) in
//                    onError()
//                }
//            }
            onError()
        }
    }
    
    // MAARK: - Logout
    static func logOut(onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            print("-> log out Erfolgreich <-")
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
        onSuccess()
    }
    
    // MARK: - Create User
    static func createCompany(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            // User erfolgreich erstelt
            guard let uid = data?.user.uid else { return }
            self.uploadUserData(uid: uid, username: username, email: email, imageData: imageData, onSuccess: onSuccess)
        }
    }
    
    // MARK: - Load Password
    static private func loadCompanyInfo() -> String? {
//        let keychain = KeychainSwift()
//        return Keychain.load("companyInformation")
        
        return Keychain.password(forAccount: "companyInformation")
    }
    
    
    
    // MARK: - User nochmal einloggen
    private static func authenicateUser() {
        guard let currentUser = UserApi.shared.CURRENT_USER else { return }
        guard let email = UserApi.shared.CURRENT_USER?.email else { return }
        guard let password = loadCompanyInfo() else { return }
            
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        currentUser.reauthenticate(with: credential) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Hat funkioniert")
        }
        
//        currentUser.reauthenticateAndRetrieveData(with: credential) { (data, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//                return
//            }
//            print("Hat funkioniert")
//        }
    }
    
    // MARK: - User Info update ----- Wichtig andere Daten noch speicher
    static func updateUserInformation(username: String, email: String, imageData: Data, countryCode: String, latitude: Double, longitude: Double, street: String, city: String, country: String, radius: Double, phone: String, mobilePhone: String, textForEverything: String, onSuccess: @escaping () -> Void, onError: @escaping(_ error: String?) -> Void) {
        guard let currentUserUid = UserApi.shared.CURRENT_USER_UID else { return }
        
        // User nochmal einloggen
        authenicateUser()
        // Daten in Authentication ändern
        UserApi.shared.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                
                // Storage
                let storageRef = Storage.storage().reference().child("company_image").child(currentUserUid)
                
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        return
                    }
                    // Datenbank
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            print("fehler1")
                            return
                        }
                        let companyImageUrlString = url?.absoluteString
                        let ref = Database.database().reference().child("users").child(currentUserUid)
                        let dic = ["username" : username, "email" : email, "companyImageUrl" : companyImageUrlString!, "countryCode" : countryCode, "latitude" : latitude, "longitude" : longitude, "street" : street, "city" : city, "country" : country, "radius" : radius ,"phone" : phone, "mobilePhone" : mobilePhone, "textForEverything" : textForEverything] as [String : Any]
                        print("was speicherst du -> \(dic)")
//                        let dic = ["username" : username, "username_lowercase" : username.lowercade(), "email" : email, "companyImageUrl" : companyImageUrlString]
                        
                        ref.updateChildValues(dic, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                onError(error?.localizedDescription)
                            } else {
                                onSuccess()
                            }
                        })
                    })
                }
                
            }
        })
    }
    
    // MARK: - Upload Payment Data
    static func uploadPaymentData(payed: Bool, amount: Double, email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        guard let currentUserUid = UserApi.shared.CURRENT_USER_UID else { return }
        authenicateUser()
        UserApi.shared.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                let ref = Database.database().reference().child("users").child(currentUserUid)
                let dic = ["payment" : payed, "amount" : amount, "email" : email] as [String : Any]
                ref.updateChildValues(dic) { (error, ref) in
                    if error != nil {
                        onError(error?.localizedDescription)
                    } else {
                        onSuccess()
                    }
                }
            }
        })
        
    }
        
        
    // MARK: - Upload Data
    // Test ohne image -- wurde wieder geändert
    // static func uploadUserData(uid: String, username: String, email: String, imageData: Data, onSuccess: @escaping () -> Void)
    static func uploadUserData(uid: String, username: String, email: String, imageData: Data, onSuccess: @escaping () -> Void) {
        
        let storageRef = Storage.storage().reference().child("company_image").child(uid)
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    print("fehler1")
                    return
                }
                let companyImageUrlString = url?.absoluteString
                let ref = Database.database().reference().child("users").child(uid)
                ref.setValue(["uid" : uid, "username" : username, "email" : email, "companyImageUrl" : companyImageUrlString])
                
                onSuccess()
            })
        }
    }
    
    // MARK: - Update Post Textlabel
    static func updatePostLabelText(postId: String, postText: String, onSuccess: @escaping () -> Void, onError: @escaping(_ error: String?) -> Void) {
        
        let ref = Database.database().reference().child("posts").child(postId)
        let dic = ["postText" : postText] as [String : Any]
        ref.updateChildValues(dic) { (error, ref) in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                onSuccess()
            }
        }
    }
    
    // MARK: - Delete Posts ----> evtl. in PostApi ablegen!!!!
    static func deletePost(postId: String, ImageUrl: String, email: String, onSuccess: @escaping () -> Void, onError: @escaping(_ error: String?) -> Void) {
        
//        guard let currentUser = UserApi.shared.CURRENT_USER_UID else { return }
        
        
        authenicateUser()
        
        UserApi.shared.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                let storageRef = Storage.storage().reference().child("posts").child(ImageUrl)
                storageRef.delete { (error) in
                    if let error = error {
                        onError(error.localizedDescription)
                        print("ErrroMessage Image URL--\(error.localizedDescription)")
                        print("IMAGE konnte nicht gelöscht werden")
                    } else {
                        onSuccess()
                        print("konnte gespeichert werden")
                    }
                }
                
                let ref = Database.database().reference().child("posts").child(postId)
                ref.removeValue { (error, ref) in
                    if error != nil {
                        onError(error?.localizedDescription)
                        print("ErrorMessage PostID--\(String(describing: error?.localizedDescription))")
                        print("PostID konnte gelöscht werden")
                    } else {
                        onSuccess()
                        print("Datenbank gelöscht")
                    }
                }
            }
        })
        
//        let storageRef = Storage.storage().reference().child("posts").child(ImageUrl)
//        print("richtige Image Url --- \(ImageUrl)")
//        storageRef.delete { (error) in
//            if let error = error {
//                onError(error.localizedDescription)
//                print("Storage löschen hat nicht funktioniert")
//            } else {
//                onSuccess()
//                print("Storage gelöscht")
//            }
//        }
        
//        let ref = Database.database().reference().child("posts").child(postId)
//        ref.removeValue { (error, ref) in
//            if error != nil {
//                onError(error?.localizedDescription)
//                print("Datenbank löschen hat nicht funktioniert")
//            } else {
//                onSuccess()
//                print("Datenbank gelöscht")
//            }
//        }
    }
}
