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
    
    private var data: [Post] = []
    private let emptyData = ParsedData()
    private var after: String? = ""
    private var subreddit = "ios"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyData.fetchData(pagination: false,subreddit: subreddit, limit: 5, after: ""){postData in
            DispatchQueue.main.async {
                self.data = postData.posts
                self.postTable.reloadData()
            }
        }
        
        subredditTItle.title = "r/\(subreddit)"
        postTable.dataSource =  self
        postTable.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NavViewController{
            destination.gainedData = data[(postTable.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! PostCell
        cell.configureView(post: data[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (postTable.contentSize.height - scrollView.frame.size.height - 100){
            guard !emptyData.paginating else{return}
            emptyData.fetchData(pagination: true, subreddit: subreddit, limit: 5, after: after!){postData in
                DispatchQueue.main.async {
                    self.data = postData.posts
                    guard let afterID = self.data.last?.after else {
                        print("After id is nill")
                        return}
                    self.after =  afterID
                    self.postTable.reloadData()
                }
            }
        }
        
    }
    
}


