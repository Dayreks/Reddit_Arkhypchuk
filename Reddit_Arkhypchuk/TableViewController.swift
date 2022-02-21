//
//  TableViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 21.02.2022.
//

import Foundation

import UIKit

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet private weak var postTable: UITableView!
    
    var data: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emptyData = ParsedData()
        emptyData.fetchData(subreddit: "ios", limit: 5, after: ""){postData in
            DispatchQueue.main.async {
                self.data = postData.posts
                self.postTable.reloadData()
            }
        }
        postTable.dataSource =  self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! PostCell
        cell.configureView(post: data[indexPath.row])
        return cell
    }
}


