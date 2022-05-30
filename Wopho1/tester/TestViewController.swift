//
//  TestViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 04.05.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import MessageUI

// Wenn daten in VC geladen werden sollen dann class CoreData behalten
import CoreData

class TestViewController: UIViewController {
    
    @IBOutlet weak var testCollectionViewCell: UICollectionView!
//    var delegateCell: TestCollectionViewCell!
    
    var post = [PostModel]()
    var companyArray = [CompanyUser]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCollectionViewCell.backgroundColor = UIColor.init(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        testCollectionViewCell.delegate = self
        testCollectionViewCell.dataSource = self
        loadData()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        navigationController?.navigationBar.backItem = .true
//
//        if navigationItem.backBarButtonItem.ishi
        
//        let backButton = UIBarButtonItem (image: UIImage(named: ), style: .plain, target: self, action: #selector(pushItem))
        
//        let backButton = UIBarButtonItem (title: "zurück", style: .plain, target: self, action: #selector(pushItem))
//        let backsButton = UIBarButtonItem (barButtonSystemItem: .compose, target: self, action: #selector(pushItem))
//        self.navigationItem.leftBarButtonItem = backButton
        
//        self.navigationController?.navigationItem.leftBarButtonItem = backButton
        
        
//        self.navigationItem.backBarButtonItem!.target = self
//        self.navigationItem.backBarButtonItem!.action = #selector(pushItem)
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "zurück", style: .plain, target: self, action: #selector(pushItem))
        
//        print("testCollectionView\(testCollectionViewCell.debugDescription)")
        
        loadPosts()
//        pushItem()
        
//        loadData()
        
//        print("companyArray\(companyArray.debugDescription)")
        
//        let backButton = UIBarButtonItem(title: "zurück", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TestViewController.backItemTapped(_:)))
        
        
//        backButtonTapped()
//        zero()
    }
    
//    func zero() {
//        delegateCell.counterIsZero()
//    }
    
    func loadPosts() {
        print("Reload_Data----<1111)")
        PostApi.shared.observePosts { (post) in
            self.post.insert(post, at: 0)
            self.testCollectionViewCell.reloadData()
            print("all_posts|||||\(post.id)")
        }
    }
    
    func loadData() {
        let companyArray = CoreData.defaults.loadData()
        if let _companyArray = companyArray {
            self.companyArray = _companyArray
        }
//        self.testCollectionViewCell.reloadData()
//        print("VC_companyArry-\(companyArray.debugDescription)")
    }
    
    @objc func backItemTapped(_ sender:UIBarButtonItem!) {
        print("funktioniert")
    }
    
    @objc func pushItem() {
        self.navigationController?.popViewController(animated: true)
        print("funktioniert")
    }
    
//    func backButtonTapped() {
//        navigationItem.backBarButtonItem?.action = #selector(pushItem)
//        print("funktioniert")
//
//    }
    
 }

extension TestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("counter testVC -> ",post.count)
        return post.count
//        return companyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
        
        cell.testPost = post[indexPath.row]
        
//        if cell.isHidden == true {
//            cell.cellIsHidden()
//        }
//        cell.loadData()
//        cell.fetchPosts()
        
//        print("Cell-Count\(cell)")
//        
//        if companyArray.count != 0 {
//            cell.testUser = companyArray[indexPath.row]
//        }
        return cell
    }
    
}

extension TestViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    // Udemy 283
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
}

// für Speicherort der App gedacht evtl.
extension TestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("klick")
//        CoreData.defaults.deleteCompanyFromData(indexPath: indexPath, companyArray: &companyArray)
    }
}
