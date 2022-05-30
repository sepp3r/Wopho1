//
//  UserViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 28.04.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import MessageUI
import Network

class UserViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Layout
    @IBOutlet weak var collectionViewCell: UICollectionView!
    @IBOutlet weak var notifyLabel: UILabel!
    
    var companyArray = [CompanyUser]()
//    var leftOverCompArray = [CompanyUser]()
//    var leftOverCompArray: [String : String] = [:]
    var core: CompanyUser?
    var collectPost = [PostModel]()
    var cacheCollectPost = [PostModel]()
    var collectUser = [UserModel]()
    var cacheCollecUser = [UserModel]()
    var testArray = ["test2000"]
    var user: UserModel?
    var userUid = ""
    var counterForDidAppear = 0
//    var comp: CompanyUser?
    var coreDataString = ""
    var cacheDataString = ""
    var imageCount = 0
    
    var markForReloadCV = false
    
    var counterCollect = 0
    
    var userUidForSegue = ""
    var postIdForSegue = ""
    var indexPathForSegue: Int = 0
    
    let buttonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    let redButtonColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    let darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markForReloadCV = false
        collectionViewCell.backgroundColor = .clear
        collectionViewCell.delegate = self
        collectionViewCell.dataSource = self
        collectionViewCell.allowsMultipleSelection = true
        
        loadData()
        fetchPost()
        self.counterForDidAppear += 1
        checkWebTraffic()
        setupLayout()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.collectPost.removeAll()
        self.collectUser.removeAll()
        self.counterForDidAppear = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if counterForDidAppear == 0 {
            //loadData()
            //fetchPost()
            
            loadData()
            print("counter --- test2 \(companyArray.count)")
            if companyArray.count != 0 {
                print("counter --- test3 \(companyArray.count)")
                //loadData()
                print("counter --- test4 \(companyArray.count)")
                checkForLoadCell()
            } else if companyArray.count == 0 {
                self.collectionViewCell.reloadData()
            }
        }
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        notifyLabel.isHidden = true
        notifyLabel.backgroundColor = redButtonColor
        notifyLabel.adjustsFontSizeToFitWidth = true
        notifyLabel.layer.cornerRadius = 2
        notifyLabel.clipsToBounds = true
    }
    
    // MARK: - Setup Notify Label
    func errorInfo() {
        notifyLabel.isHidden = false
        notifyLabel.translatesAutoresizingMaskIntoConstraints = true
        notifyLabel.numberOfLines = 2
        notifyLabel.lineBreakMode = .byCharWrapping
        notifyLabel.text = "Fehler, das Update \ndeiner likes ging leider schief"
        notifyLabel.adjustsFontSizeToFitWidth = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notifyLabel.frame.origin.x -= 254
        } completion: { (end) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
                    self.notifyLabel.frame.origin.x += 254
                } completion: { (end) in
                    self.notifyLabel.isHidden = true
                }
            }
        }
    }
    
    func deletintTheIdWasSuccess() {
        notifyLabel.isHidden = false
        notifyLabel.translatesAutoresizingMaskIntoConstraints = true
        notifyLabel.numberOfLines = 2
        notifyLabel.lineBreakMode = .byCharWrapping
        notifyLabel.text = "Anbieter löschte einen Post, \nwir haben deine Wunschliste aktualisiert"
        notifyLabel.adjustsFontSizeToFitWidth = true
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear) {
            self.notifyLabel.frame.origin.x -= 254
        } completion: { (end) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
                    self.notifyLabel.frame.origin.x += 254
                } completion: { (end) in
                    self.notifyLabel.isHidden = true
                }
            }
        }

    }
    
    func whlieTest() {
        while true {
            print("Wunschlist Problem - CoreData Count \(self.companyArray.count) && collectPost Count - \(self.collectPost.count)")
            if companyArray.count == collectPost.count {
                self.performSegue(withIdentifier: "showResultVC", sender: self)
                break
            } else {
                loadPost()
            }
        }
    }
    
    // MARK: - Upload Data
        
    func fetchPost() {
        if companyArray.count != 0 {
            print("coreIndex Check -> count", companyArray.count)
            counterCollect = companyArray.count
            for index in companyArray {
                print("coreIndex Check -> \(index.postUid) && \(index.postLike) && \(index.debugDescription)")
                coreDataString = index.postUid!
                core = index
                loadPost()
            }
        }
    }
    
    
    
    func fetchViewDidAppear() {
        if self.companyArray.count != 0 {
            self.counterCollect = self.companyArray.count
            for index in self.companyArray {
                self.coreDataString = index.postUid!
                self.core = index
                loadViewDidAppear()
            }
        }
    }
    
    
    func fetchForDidDisappear_NotGood() {
        if companyArray == cacheCollectPost {
            print("markForReloadCV 1 = false")
        } else {
            print("markForReloadCV 1 = _____ TRUE ____")
        }
        if companyArray.count != 0 {
            counterCollect = companyArray.count
            DispatchQueue.global(qos: .default).async {
                for (i, item) in self.companyArray.enumerated() {
                    for (index, object) in self.cacheCollectPost.enumerated() {
                       // print("markForReloadCV -> i \(i) &&& index \(index)")
                        if i == index {
                            //print("markForReloadCV 1 = false")
                            if item == object {
                                //print("markForReloadCV 2 = false")
                            } else {
                                self.markForReloadCV = true
                                //print("markForReloadCV 1 = -> TRUE <-")
                            }
                        } else {
                            self.markForReloadCV = true
                            //print("markForReloadCV 2 = -> TRUE <-")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                
            }
            
        }
    }
    
    
    func loadPostOld() {
        print("seig mir mein -> coreDataString \(self.coreDataString)")
        
        
        PostApi.shared.observePostforWishList(withPodId: coreDataString) { (post, invalid) in
            
            print("seig mir mein -> INVALID --------__________ \(invalid) && postId \(post.uid)")
            if invalid != "" {
                print("seig mir mein -> not in Datatbase - \(invalid) && der Post -> \(post)")
                self.deleteCoreDataId(id: invalid)
            } else {
                self.userUid = post.uid!
                print("seig mir mein -> Datatbase ----------- \(invalid) && der Post -> \(post.postId)")
                UserApi.shared.observeUser(uid: self.userUid) { (Id) in
                    
                    self.collectUser.append(Id)
                    self.collectPost.append(post)
                    self.collectionViewCell.reloadData()
                    print("ich bin da mal weg---- äh oder doch nicht --> count \(self.collectPost.count)")
            }
            }
        }
        
        
//        PostApi.shared.observePost(withPodId: coreDataString) { (post) in
//
//            print("seig mir mein -> der Vergleich core \(self.coreDataString) _____ post.Id \(post.id)")
//
//
//        }
        
    }
    
    func loadPost() {
        PostApi.shared.observePostforWishList(withPodId: coreDataString) { (post, invalid ) in
            if invalid != "" {
                self.deleteCoreDataId(id: invalid)
                self.cacheCollectPost.removeAll()
            } else if self.cacheCollectPost.count == 0 {
                self.userUid = post.uid!
                UserApi.shared.observeUser(uid: self.userUid) { (Id) in
                    self.collectUser.append(Id)
                    self.collectPost.append(post)
                    self.cacheCollectPost = self.collectPost
                    self.cacheCollecUser = self.collectUser
                    self.collectionViewCell.reloadData()
                    print("das sollte laden")
                    print("load eintragen --- RELOAD")
                }
            } else if self.cacheCollectPost.count > 0 {
                self.collectPost = self.cacheCollectPost
                self.collectUser = self.cacheCollecUser
            }
            
        }
    }
    
    func testereins() {
        let testA = Set(collectPost)
        let testB = Set(cacheCollectPost)
        
        let both = testA.intersection(testB)
        
    }
    
    func checkForLoadCell() {
        print("counter --- test1 \(companyArray.count)")
        let counter = companyArray.count - 1
        print("counter --- test2 \(counter)")
        var counterSec = 0
        for index in 0 ... counter {
            if companyArray.count == cacheCollectPost.count {
                if companyArray[index].postUid != cacheCollectPost[index].postId {
                    print("load eintragen1")
                    fetchViewDidAppear()
                    break
                } else {
                    counterSec += 1
                    print("load eintragen --- \(counterSec)")
                    if companyArray.count == counterSec {
                        collectPost = cacheCollectPost
                        collectUser = cacheCollecUser
                        counterSec = 0
                        if self.companyArray.count != 0 {
                            for index in self.companyArray {
                                self.coreDataString = index.postUid!
                                self.core = index
                                PostApi.shared.observePostforWishList(withPodId: coreDataString) { (post, invalid) in
                                    if invalid != "" {
                                        //self.deleteCoreDataId(id: invalid)
                                        self.collectPost.removeAll()
                                        self.collectUser.removeAll()
                                        self.fetchViewDidAppear()
                                        print("coreDataString !! -> \(self.coreDataString)")
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("load eintragen2")
                fetchViewDidAppear()
                break
            }
        }
    }
    
    func testderWhile() {
        let counter = companyArray.count - 1
        print("while Test - 23456 \(counter)")
        print("coreDataTest - Phase -- 2 \(self.coreDataString)")
        for i in 0 ... counter {
            if companyArray.count == cacheCollectPost.count {
                print("while Test - comp \(companyArray[i].postUid) && cache \(cacheCollectPost[i].postId)")
                if companyArray[i].postUid != cacheCollectPost[i].postId {
                    print("while Test ->>> CollectionView muss neu geladen werden 1111")
                } else {
                    print("while Test ->>> Passt alles")
                }
            } else {
                print("while Test ->>> CollectionView muss neu geladen werden 2222")
            }
            
        }
    }
    
    func loadViewDidAppear() {
        PostApi.shared.observePostforWishList(withPodId: coreDataString) { (post, invalid) in
            if invalid != "" {
                self.deleteCoreDataId(id: invalid)
                self.cacheCollectPost.removeAll()
            } else {
                self.userUid = post.uid!
                UserApi.shared.observeUser(uid: self.userUid) { (Id) in
                    self.collectUser.append(Id)
                    self.collectPost.append(post)
                    self.cacheCollectPost = self.collectPost
                    self.cacheCollecUser = self.collectUser
                    self.collectionViewCell.reloadData()
                }
            }
        }
    }
    
    func loadPostForDidDisappear() {
        print("indexTest Comp -> \(self.coreDataString) && cache -> \(self.cacheDataString)")
        PostApi.shared.observePostforWishList(withPodId: coreDataString) { (post, invalid) in

            if invalid != "" {
                self.deleteCoreDataId(id: invalid)
                self.cacheCollectPost.removeAll()
            } else if self.collectUser.count == 0 {
                self.userUid = post.uid!
                UserApi.shared.observeUser(uid: self.userUid) { (Id) in
                    self.collectUser.append(Id)
                    self.collectPost.append(post)
                    if self.markForReloadCV == true {
                        self.collectionViewCell.reloadData()
                        self.cacheCollectPost = self.collectPost
                        self.cacheCollecUser = self.collectUser
                        print("markForReloadCV ---> RESULT <--- -> TRUE <-")
                    }
                }
            } else if self.cacheCollectPost.count > 0 {
                self.collectPost = self.cacheCollectPost
                self.collectUser = self.cacheCollecUser
            }
        }
    }
    
    func fetchUserUid() {
        UserApi.shared.observeUser(uid: userUid) { (id) in
            self.user = id
            self.collectionViewCell.reloadData()
        }
    }
    
    // MARK: - Check the Internet
    func checkWebTraffic() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.yeahConnection()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.noConnection()
                }
            }
        }
    }
    
    func yeahConnection() {
        
    }
    
    func noConnection() {
        
    }
    
    // MARK: - Delete CoreData Id && Load
    func deleteCoreDataId(id: String) {
        for index in companyArray {
            if index.postUid == id {
                let coreIndex = index.self
                CoreData.defaults.context.delete(coreIndex)
                CoreData.defaults.saveContext()
                deletintTheIdWasSuccess()
                continue
            }
        }
    }
    
    func loadData() {
        let companyArray = CoreData.defaults.loadData()
        if let _companyArray = companyArray {
            self.companyArray = _companyArray
        }
        print("counter --- test000000")
    }
    
    func deleteCoreAll() {
        CoreData.defaults.deleteCoreDataStuff()
    }
    
    // MARK: - Email Setup
    
    func mailSetup() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["s.schmitt@sld-logistik.de"])
            mail.setSubject("test Mail")
            mail.setMessageBody("Nachricht sollte da stehen", isHTML: false)
            self.present(mail, animated: true, completion: nil)
            
        } else {
            
        }
    }
    
    func showMailError() {
        let error = UIAlertController(title: "Email konnte nicht gesendet werden", message: "Bitte prüfen sie deine Email-Einstellugen", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    // MARK: - Phone Setup
    
    func errorEmptyPhoneNumber() {
        let error = UIAlertController(title: "Achtung", message: "Es wurde keine Nummer hinterlegt", preferredStyle: .alert)
        error.addAction(UIAlertAction(title: "Zurück", style: .cancel, handler: nil))
        self.present(error, animated: true, completion: nil)
    }
    
    
    // 2. Variante
//    enum Storage {
//        case userDefault
//        case fileSystems
//    }
    

    
    // 3. Variante
    
    
    @IBAction func unwindToUserVC(_ windSegue: UIStoryboardSegue) {
    }
    
    // 1. Variante
//    func getImage(image: String) {
//        let fileManager = FileManager.default
//
//        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString).appendingPathComponent(image)
//
//        print("imagePath Inhalt ->>>", imagePath.debugDescription)
//
//        if fileManager.fileExists(atPath: imagePath) {
////            postCardImage.image = UIImage(contentsOfFile: imagePath)
//        } else {
//            print("funktioniert nicht")
//        }
//    }
    
    // 2. Variante
//    private func retrieveImage(forKey key: String, inStorageType storageType: Storage) -> UIImage? {
//        switch storageType {
//        case .fileSystems:
//            if let filePaths = self.filePath(forKey: key),
//                let fileData = FileManager.default.contents(atPath: filePaths.path),
//                let image = UIImage(data: fileData) {
//                return image
//            }
//        case .userDefault:
//            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
//                let image = UIImage(data: imageData) {
//
//                return image
//            }
//        }
//
//        return nil
//    }
//
//    private func filePath(forKey key:String) -> URL? {
//        let fileManager = FileManager.default
//        guard let URL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
//
//        return URL.appendingPathComponent(key + ".png")
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultVC" {
            let searchVC = segue.destination as! SearchResultViewController
//            searchVC.cardPostId = postIdForSegue
//            searchVC.coreDataArray = companyArray
//            searchVC.myTextSearch = "Deine Likes"
            searchVC.backButtonTargetId = "unwindToUserVC"
            searchVC.searchText = "Deine Wunschliste"
            searchVC.wishlist = "wishlist"
            counterForDidAppear = 0
            if collectPost.count == 0 {
                searchVC.seguePost = cacheCollectPost
            } else {
                searchVC.seguePost = collectPost
            }
            
            print("Wunschlist Problem - Source -> collecPost.count \(collectPost.count)")
            searchVC.reachedIndexFromWish = indexPathForSegue
            searchVC.infoByUserLibrary()
        }
    }
    
    
    
    
}
// MARK: - CollectionView Datasource
extension UserViewController: UICollectionViewDataSource {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        var value = 0
//        if testArray.count != 0 {
//            value = 2
//        } else {
//            value = 1
//        }
//
//        return value
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageTest.count
//        print("countCellView----\(collectPost.count)")
//        let counter = collectPost.count + testArray.count
        
        return collectPost.count
//        return counterCollect
//        return counter
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        
        cell.post = collectPost[indexPath.row]
        print("was bist du für einer \(collectUser.count)")
        cell.user = collectUser[indexPath.row]
        cell.delegate = self
        cell.delegatePostImage = self
        cell.delegateForDelete = self
        cell.indexRow = indexPath.row
        
        
        print("ich bin ein zu viel111111")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserHeaderCollectionViewCell", for: indexPath) as! UserHeaderCollectionViewCell
        
//        cell.contentView.isUserInteractionEnabled = false
        
//        if let core = self.core {
//            cell.core = core
//        }
        
//        if let counter = self.counterCollect {
//            cell.counter = counterCollect
//        }
        
        
        
        cell.counter = collectPost.count
        print("userCount \(counterCollect)")
        
        return cell
    }
}

extension UserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2.19 - 1
        let height: CGFloat = collectionView.frame.height / 3.05 - 1
        let size = CGSize(width: width, height: height)
        
        return size
    }
}

extension UserViewController: PostImageDelegate {
    func tappedImage(userUid: String, postId: String, indexPath: Int) {
        self.indexPathForSegue = indexPath
        self.userUidForSegue = userUid
        self.postIdForSegue = postId
        self.counterForDidAppear = 0
        performSegue(withIdentifier: "showResultVC", sender: self)
    }
}

extension UserViewController: DeleteInfo {
    func tappedDelete() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear) {
            //self.collectPost.removeAll()
            //self.collectUser.removeAll()
            self.cacheCollecUser.removeAll()
            self.cacheCollectPost.removeAll()
            self.counterForDidAppear = 0
        } completion: { (end) in
            //self.loadData()
            //self.fetchPost()
            //self.counterForDidAppear += 1
        }
    }
}
