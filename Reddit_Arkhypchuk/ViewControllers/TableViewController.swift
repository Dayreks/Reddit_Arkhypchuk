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
    @IBOutlet private weak var saved: UIBarButtonItem!
    
    private let postsController = PostRepository()
    private var savedActive: Bool = false
    
    @IBAction func savedPosts(_ sender: Any) {
        savedActive.toggle()
        self.saved.image = savedActive ? UIImage(systemName: "book.fill") : UIImage(systemName: "book")
        postsController.data = savedActive ? postsController.dataSaved : postsController.dataBackUp
        postTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsController.loadSavedPosts()
        postsController.initPosts{self.postTable.reloadData()}
        
        SceneDelegate.shared?.takeSavedPosts(data: postsController)
        
        subredditTItle.title = "r/\(postsController.subreddit)"
        postTable.dataSource =  self
        postTable.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NavViewController{
            destination.gainedData = postsController.data[(postTable.indexPathForSelectedRow?.row)!]
            destination.delegate = self
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsController.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! PostCell
        cell.configureView(post: postsController.data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!savedActive){
            let postion = scrollView.contentOffset.y
            if postion > (postTable.contentSize.height - scrollView.frame.size.height - 100){
                postsController.loadMorePosts(amount: 5)
                postTable.reloadData()
            }
        }
    }
}

extension TableViewController: PostCellDelagate, NavViewControllerDelegate {
    func recieveController() -> PostRepository {
        return postsController
    }
    
    
    func saveData(post: Post) {
        if(!post.isSaved){
            postsController.savePost(post)
        } else{
            postsController.removePost(post)
        }
    }
    
    func loadSavedData(){
        postsController.loadSavedPosts()
    }
    
    func shouldShare(post: Post) {
        let items = [post.link]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    
}







