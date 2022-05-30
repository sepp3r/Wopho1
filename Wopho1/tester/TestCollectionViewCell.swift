//
//  TestCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 05.05.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import SDWebImage

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var testHeartButton: UIButton!
    
    // 2. Variante
    
//    enum Storage {
//        case userDefault
//        case fileSystems
//    }
    
//    var testDing: CompanyUser?
    
    // zähler für die while loop -> static vor der variable wurde entfernt
//    var counter: Int = 0
    
    var companyArray = [CompanyUser]()
    var coreDataString = ""
    
//    var collectPost = [PostModel]()
    
    // var laden der Daten
    var likes: Int16 = 0
    

    
    // var f. Speicherung
    var savePostId: String = ""
    var postlike: Int16 = 1
   
    // Error Message zuständig
    var delegate: TestViewController!
    
    var testPost: PostModel? {
        didSet {
            guard let _testPost = testPost else { return }
            testInformation(testPost: _testPost)
            
        }
    }
    
    var testUser: CompanyUser? {
        didSet {
            guard let _testUser = testUser else { return }
            testUserCompany(testUser: _testUser)
        }
    }
    
    override func awakeFromNib() {
        
        
//        fetchPosts()
        
//        loadData()
//        fetchPost()
//        test2000()
//        compareId()
        
//        if coreDataString == savePostId {
//            testHeartButton.backgroundColor = .white
//        }
    }
    
    func testUserCompany(testUser: CompanyUser) {
//        coreDataString = testUser.postUid!
//        if testUser.postUid == savePostId.description {
//            testHeartButton.backgroundColor = .white
//        }
    }
    
    func testInformation(testPost: PostModel) {
//        print("counter bei start", counter)
        testImage.layer.cornerRadius = 10
        testImage.clipsToBounds = true
        testHeartButton.backgroundColor = .clear
        
//        print("postId---\(testPost.id)")
        
//        heartButtonTapped()
        savePostId = testPost.id!
        
        loadData()
        fetchPosts()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print("PostModel--Counter", TestCollectionViewCell.counter)
//        print("Count-Company-Array\(companyArray.count)")
        
//        compareId()
//        fetchPost()
        
//        loadLike()
        
//        compareId()
//        print("identisch \(savePostId) == \(coreDataString)")
//        if savePostId == coreDataString {
//            print("identisch \(savePostId) == \(coreDataString)")
//            testHeartButton.backgroundColor = .white
//        }
        
//        print("likes----\(likes)")
        guard let url = URL(string: testPost.imageUrl!) else { return }
        testImage.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
    // MARK: - Load Core Data
//    func fetchPost() {
////        print("companyArray\(companyArray.count)")
//        if companyArray.count != 0 {
//            for index in companyArray {
//                coreDataString = index.postUid!
////                print("compayArray\(index.postUid)")
////                print("----ENDE----")
////                likes = index.postLike
////                if index.postLike == 1 {
////                    testHeartButton.backgroundColor = .white
////                }
////                compareId()
////                print("läuft das???")
//            }
//        }
//    }
    
    func fetchPosts() {
//        counter += 1
        for index in companyArray {
//            print("fetch---\(index.postUid)+\(testPost?.id)")
//            if index.postUid == testPost?.id && counter <= companyArray.count
            if index.postUid == testPost?.id {
//                print("fetch---\(index.postUid)+\(testPost?.id)")
//                print("counter_Vergleich \(TestCollectionViewCell.counter) + \(companyArray.count)")
                testHeartButton.backgroundColor = .white
//                counter += 1
//                print("counter_fetchPosts", TestCollectionViewCell.counter)
                continue
//else if index.postUid != testPost?.id && counter >= companyArray.count
            } else if index.postUid != testPost?.id {
//                print("Button is Clear -----")
//                testHeartButton.backgroundColor = .clear
//else if index.postUid != testPost?.id && TestCollectionViewCell.counter >= companyArray.count
//                print("counter -else ", TestCollectionViewCell.counter)
            }
        }
    }
    
    func deleteCollectCard() {
        for index in companyArray {
            print("index----\(index.postUid)")
            if index.postUid == testPost?.id {
                print("index----\(index.postUid)")
                let test = index.self
                print("test\(test)")
                CoreData.defaults.context.delete(test)
                CoreData.defaults.saveContext()
                continue
            } else {
                // error funktion prüfen
                print("else")
            }
        }
        print("deleteCollectCard")
    }
    
    
    func deletePosts() {
        guard let user = companyArray.first else { return }
        CoreData.defaults.context.delete(user)
        print("deletePosts")
    }
    
    func cellIsHidden() {
        for index in companyArray {
//            print("hidden---\(index.postUid)+\(testPost?.id)")
//            if index.postUid == testPost?.id && counter != 0 && testHeartButton.backgroundColor == .white
            if index.postUid == testPost?.id && testHeartButton.backgroundColor == .white {
                
//                counter -= 1
//                print("counter---cellIsHidden", TestCollectionViewCell.counter)
                continue
            }
        }
    }
    
//    func counterIsZero() {
//        counter = 0
//    }
    
    func loadData() {
        print("funktioniert_companyArray")
        let companyArray = CoreData.defaults.loadData()
//        print("CoreData.defaults----\(companyArray.debugDescription)")
        if let _companyArray = companyArray {
            self.companyArray = _companyArray
            
            print("companyArray--Anzahl\(companyArray?.count)")
            
        }
    }
    
//    func compareId() {
////        print("Der vergleich \(savePostId) == \(coreDataString)")
////        if savePostId == coreDataString
//        if testUser?.postUid == testPost?.id {
////            print("Der vergleich \(savePostId) == \(coreDataString)")
//            testHeartButton.backgroundColor = .white
////            print("---identisch---")
//        }
////        testHeartButton.backgroundColor = .clear
////        print("nicht identisch")
//
//    }
    
    // MARK: - Save Core Data
    func saveCompany() {
        if savePostId.count != 0 {
            let postId = CoreData.defaults.createData(_postUid: savePostId)
        } else {
            errorMess()
        }
        
    }
    
    func errorMess() {
        let error = UIAlertController(title: "Hinweis", message: "Sammelkarte konnte nicht geladen werden, starte die App erneut!", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Bestätigen", style: .default, handler: nil))
        self.delegate.present(error, animated: true, completion: nil)
    }
    
    
    // Button Action
    @IBAction func testHeartButtonTapped(_ sender: UIButton) {
//        print("Image_Id---\(testPost?.id)")
//        deleteCollectCard()
        
        if testHeartButton.backgroundColor == .clear {
            testHeartButton.backgroundColor = .white
            saveCompany()
        } else {
            testHeartButton.backgroundColor = .clear
            deleteCollectCard()
            
        }
    }
    
    
    // 1. Variante funktioniert aber nur mit einen bild, nicht mehr möglich
//    func saveImage(image: String) {
//        let fileManager = FileManager.default
//
//        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString).appendingPathComponent(image)
//
//        let image = testImage.image!
//        let data = image.pngData()
//
//        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
//
//        print(imagePath)
//    }
    
    // 2. Variante
//    private func store(image: UIImage, forkey key: String, withStorageType storageType: Storage) {
//        if let pngRepr = image.pngData() {
//            switch storageType {
//            case .fileSystems:
//                if let filePath = filePath(forKey: key) {
//                    do {
//                        try pngRepr.write(to: filePath, options: .atomic)
//                    } catch let err {
//                        print("klappt nicht", err)
//                    }
//                }
//            case .userDefault:
//                UserDefaults.standard.set(pngRepr, forKey: key)
//            }
//        }
//    }
//
//    private func filePath(forKey key:String) -> URL? {
//        let fileManager = FileManager.default
//        guard let URL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
//
//        return URL.appendingPathComponent(key + ".png")
//    }
    
    // Action Button ander verwenden
//    func heartButtonTapped() {
//        testHeartButton.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
//        print("button funktioniert")
//    }
//
//    @objc func deleteAction() {
//        if testHeartButton.backgroundColor == .white{
////            CoreData.defaults.context.delete(companyArray[1])
//            testHeartButton.backgroundColor = .clear
//        } else if testHeartButton.backgroundColor == .clear {
//            testHeartButton.backgroundColor = .white
//            saveCompany()
//        }
        
//        if testUser?.postUid == testPost?.id {
//            testHeartButton.backgroundColor = .white
//        } else if testUser?.postUid != testPost?.id {
//            testHeartButton.backgroundColor = .clear
//        }
    

    
    // war die heartButtonTappen -> Action function
//    if testHeartButton.backgroundColor != .white {
//                testHeartButton.backgroundColor = .white
//                // 3. Variante
//                saveCompany()
//                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//            } else {
//                testHeartButton.backgroundColor = .clear
//                deletePosts()
//
//
//                // V5
//
//
//                // 3. Variante -> löschen der Daten
//    //            CoreData.defaults.deleteCoreDataStuff()
//
//                // V3
//    //            CoreData.defaults.deleteRecords()
//
//                // V4
//    //            CoreData.defaults.deleteContext(postId: savePostId, companyArray: &)
//            }
        
        
        
        // 1. Variante
//        saveImage(image: "png")
        
        // 2. Variante
//        if let Image = UIImage(named: "imagePNG") {
//            DispatchQueue.global(qos: .background).async {
//                self.store(image: Image, forkey: "image", withStorageType: .fileSystems)
//            }
//        }
    
}
