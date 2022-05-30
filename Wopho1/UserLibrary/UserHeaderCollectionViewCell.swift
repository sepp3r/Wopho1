//
//  UserHeaderCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.05.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import CoreData

class UserHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionCardLabel: UILabel!
    @IBOutlet weak var collectionCardCount: UILabel!
    
    
    // MARK: - var / let
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var coreDataArry = [CompanyUser]()
    var loadedCoreData = [CompanyUser]()
    
    var counter = 0 {
        didSet {
           self.collectionCardCount.text = "\(counter)"
            collectionCardCount.textColor = .white
            collectionCardLabel.textColor = .white
            
//            collectionCardCount.layer.cornerRadius = collectionCardCount.bounds.width/2
//
//            collectionCardCount.backgroundColor = .white
//            collectionCardCount.layer.borderWidth = 2
//            collectionCardCount.tintColor = truqButtonColor
//            collectionCardCount.layer.borderColor = collectionCardCount.tintColor.cgColor
//            collectionCardCount.clipsToBounds = true
            loadCoreData()
            
            
        }
    }
    
    func loadCoreData() {
        let coreDataArray = CoreData.defaults.loadData()
        if let _coreDataArry = coreDataArray {
            self.loadedCoreData = _coreDataArry
            self.coreDataArry = _coreDataArry
            print("data geladen \(loadedCoreData.count)")
        }
    }
    
    func deleteCollect() {
        print("bis wann gehst 0.5")
        for index in coreDataArry {
            print("bis wann gehst 1")
            for indexSec in loadedCoreData {
                print("bis wann gehst 2")
                if index.postUid == indexSec.postUid {
                    print("bis wann gehst 3")
                    let coreIndex = index.self
                    CoreData.defaults.context.delete(coreIndex)
                    CoreData.defaults.saveContext()
                    print("löschen von CoreData hat geklappt")
                    continue
                } else {
                    print("error Alert in USERHEADER ----")
                }
            }
        }
    }
    
    
    
//    var core: CompanyUser? {
//        didSet {
//            guard let _core = core else { return }
//            coreInformation(core: _core)
//        }
//    }
    
//    func coreInformation(core: CompanyUser) {
//        collectionCardCount.textColor = .white
//        collectionCardLabel.textColor = .white
//        let counter = core.postLike
//        self.collectionCardCount.text = "\(counter)"
//        
//    }
    
}
