//
//  UpgradeInfoViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 19.12.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit

class UpgradeInfoViewController: UIViewController {
    
    
    
    // MARK: - var / let
    let themeArray = ["Kosten", "Unbegrenzte Posts", "Sichtbarkeit", "Schnelligkeit", "Kunden nähe", "Reichweite"]
    
    
    // MARK: - Layout
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        infoCollectionView.dataSource = self
        
    }
    
    
    // MARK: - Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromUpgradeInfo", sender: self)
    }
    
    
}

extension UpgradeInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upgradeInfoCell", for: indexPath) as? UpgradeInfoCollectionViewCell {
            cell.themeLabel.text = themeArray[indexPath.row]
            cell.backgroundColor = .clear
            cell.layer.borderColor = cell.tintColor.cgColor
            cell.tintColor = .white
            cell.layer.borderWidth = 1.5
            cell.layer.cornerRadius = 5
            cell.detailTextview.isEditable = false
            cell.detailTextview.isScrollEnabled = false
            cell.clipsToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
}
