//
//  HomeViewControllerUpdating.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 24.01.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

//extension HomeViewController: UISearchResultsUpdating {
//    
//    private func findMatches(searchString: String) -> NSCompoundPredicate {
//        
//        var searchItemsPredicate = [NSPredicate]()
//        
//        let titleExpression = NSExpression(forKeyPath: UserModel.ExpressionKey.username.rawValue)
//        
//        let searchExpresssion = NSExpression(forConstantValue: searchString)
//        
//        let searchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchExpresssion, modifier: .direct, type: .contains, options: [.caseInsensitive, .diacriticInsensitive])
//        
//        searchItemsPredicate.append(searchComparisonPredicate)
//        
//        var finalCompoundPredicate: NSCompoundPredicate!
//        
//        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
//        if selectedScopeButtonIndex > 0 {
//            if !searchItemsPredicate.isEmpty {
//                let compPredicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: searchItemsPredicate)
//                let compPredicate2 = NSPredicate(format: "(SELF.type == %1d)", selectedScopeButtonIndex)
//                
//                finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
//            } else {
//                finalCompoundPredicate = NSCompoundPredicate(format: "(SELF.type == %1d)", selectedScopeButtonIndex)
//            }
//        } else {
//            
//            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
//        }
//        
//        return finalCompoundPredicate
//        
//    }
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchResults = users
//        
//        let whitespaceCharacterSet = CharacterSet.whitespaces
//        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
//        let searchItems = strippedString.components(separatedBy: " ") as [String]
//        
//        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
//            findMatches(searchString: searchString)
//        }
//        
//        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
//        
//        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
//        
//        if let resultController = searchController.searchResultsController as? ResultTableViewController {
//            resultController.searching = filteredResults
//            resultController.tableView.reloadData()
//            
//        }
//        
//    }
//    
//    
//}
