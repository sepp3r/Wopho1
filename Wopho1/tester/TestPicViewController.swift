//
//  TestPicViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 06.05.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

class TestPicViewController: UIViewController {

    @IBOutlet weak var secondImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getImage(image: "png")
        
    }
    
    // 1. Versuch funktioniert aber nur mit einen bild, nicht mehr möglich
//    func getImage(image: String) {
//        let fileManager = FileManager.default
//
//        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString).appendingPathComponent(image)
//
//        if fileManager.fileExists(atPath: imagePath) {
//            secondImage.image = UIImage(contentsOfFile: imagePath)
//        } else {
//            print("funktioniert nicht")
//        }
//    }
    
    
}
