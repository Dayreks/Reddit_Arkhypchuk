//
//  TableViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 21.02.2022.
//

import Foundation

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate {
    
    @IBOutlet private weak var postTable: UITableView!
    @IBOutlet private weak var subredditTItle: UINavigationItem!
    
    private let postsController = PostRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsController.initPosts{self.postTable.reloadData()}
        
        subredditTItle.title = "r/\(postsController.subreddit)"
        postTable.dataSource =  self
        postTable.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NavViewController{
            destination.gainedData = postsController.data[(postTable.indexPathForSelectedRow?.row)!]
        }
    }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsController.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! PostCell
        cell.configureView(post: postsController.data[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (postTable.contentSize.height - scrollView.frame.size.height - 100){
            postsController.loadMorePosts(amount: 5)
            postTable.reloadData()
        }
    }
}


