//
//  LinkPresentationItemSource.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 29.12.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import LinkPresentation

class LinkPresentationItemSource: NSObject, UIActivityItemSource {
   
    var linkMetaData = LPLinkMetadata()
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Placeholder"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return linkMetaData.originalURL
    }
    
    init(metaData: LPLinkMetadata) {
        self.linkMetaData = metaData
    }
    
    
    
    
    
    
}
