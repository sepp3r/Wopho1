//
//  ResultTableViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 09.01.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    // MARK: - let / var
    let tableViewCell = "cellID"
    //var searching = [PostModel]()
    var searching = [UserModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---ResultTableViewController-------------")
//        searchBarPostLoad()
        
        let nib = UINib(nibName: "TableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableViewCell)
        //resultTableViewCell.register(nib, forCellReuseIdentifier: tableViewCell)
    }
    
//    func searchBarPostLoad() {
//        PostApi.shared.observePosts { (post) in
//            self.searching.append(post)
//            self.tableView.reloadData()
//        }
//    }
    
    // Vor test beginn -> momentan Absturz bei SearchBar
    func searchBarPostLoad() {
        UserApi.shared.observeUsers { (user) in
            self.searching.append(user)
            self.tableView.reloadData()
            print("---ResultTableViewController-------------")
        }
    }
    


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = super.tableView(tableView, numberOfRowsInSection: section)
//        print("SearchCOUNT ---- \(searching.count)")
//        if searching.count >= 1 {
//            return count - 1
//        }
        print("SearchCOUNT ---- \(searching.count)")
//        return count
        return searching.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCell, for: indexPath)
        
        let search = searching[indexPath.row]
        
        //cell.textLabel?.text = search.postText
        
        cell.textLabel?.text = search.username
        

        return cell
    }
}
