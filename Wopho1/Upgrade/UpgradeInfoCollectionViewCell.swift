//
//  UpgradeInfoCollectionViewCell.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 20.12.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit

class UpgradeInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Text
    // "Kosten", "Unbegrenzte Posts", "Sichtbarkeit", "Schnelligkeit", "Kunden nähe", "Reichweite"
    let costText = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    let unlimitedText = "unlimited Text"
    let visibleText = "visiblie Text"
    let speedText = "speed Text"
    let customerText = "customer Text"
    let rangeText = "range Text"
    
    // MARK: - Layout
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var detailTextview: UITextView!
    
    override func layoutSubviews() {
        themeLabel.isHidden = false
        detailTextview.isHidden = false
        whichText()
    }
    
    func whichText() {
        switch themeLabel.text {
        case "Kosten":
            detailTextview.text = costText
        case "Unbegrenzte Posts":
            detailTextview.text = costText
        case "Sichtbarkeit":
            detailTextview.text = costText
        case "Schnelligkeit":
            detailTextview.text = costText
        case "Kunden nähe":
            detailTextview.text = costText
        case "Reichweite":
            detailTextview.text = costText
        default:
            themeLabel.isHidden = true
            detailTextview.isHidden = true
            
        }
    }
}
