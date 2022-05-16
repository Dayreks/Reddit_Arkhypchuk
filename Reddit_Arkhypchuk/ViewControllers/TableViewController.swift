//
//  TableViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 21.02.2022.
//

import Foundation

import UIKit


class TableViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet private weak var postTable: UITableView!
    @IBOutlet private weak var subredditTItle: UINavigationItem!
    @IBOutlet private weak var saved: UIBarButtonItem!
    @IBOutlet private var searchBar: UISearchBar!
    
    
    private var savedActive: Bool = false
    
    //MARK: Saved Posts Filter
    
    @IBAction func savedPosts(_ sender: Any) {
        savedActive.toggle()
        
        self.saved.image = savedActive ? UIImage(systemName: "book.fill") : UIImage(systemName: "book")
        
        PostRepository.shared.data = savedActive ? PostRepository.shared.dataSaved : PostRepository.shared.dataBackUp
        postTable.reloadData()
        
        subredditTItle.title = savedActive ?  "Saved": "r/\(PostRepository.shared.subreddit)"
        
        scrollUp()
        subredditTItle.titleView = savedActive ? searchBar : nil
    }
    
    func scrollUp(){
        if(!PostRepository.shared.dataSaved.isEmpty){self.postTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostRepository.shared.loadSavedPosts()
        PostRepository.shared.initPosts {self.postTable.reloadData()}
        
        subredditTItle.title = "r/\(PostRepository.shared.subreddit)"
        
        self.postTable.keyboardDismissMode = .onDrag
        searchBar.delegate = self

        postTable.dataSource =  self
        postTable.delegate = self
        
        postTable.rowHeight = UITableView.automaticDimension
        postTable.estimatedRowHeight = 600
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        postTable.reloadData()
    }
    
    
    
    // MARK: Navigation View
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NavViewController{
            destination.gainedData = PostRepository.shared.data[(postTable.indexPathForSelectedRow?.row)!]
            destination.delegate = self
        }
    }

    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostRepository.shared.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath) as! PostCell
        cell.delegate = self
        cell.configureView(post: &PostRepository.shared.data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!savedActive){
            let postion = scrollView.contentOffset.y
            if postion > (postTable.contentSize.height - scrollView.frame.size.height - 100){
                PostRepository.shared.loadMorePosts(amount: 5)
                postTable.reloadData()
            }
        }
    }
    
    
    
    //MARK: Search Bar Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let dataFiltered = PostRepository.shared.dataSaved.filter{$0.title.lowercased().contains(searchText.lowercased())}
        PostRepository.shared.data = searchText != ""  ? dataFiltered : PostRepository.shared.dataSaved
        postTable.reloadData()
        if(!PostRepository.shared.data.isEmpty){self.postTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)}
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
     }
}


extension TableViewController: PostCellDelagate {
    
    
    func saveData(post: inout Post) {
        if(!post.isSaved){
            PostRepository.shared.savePost(post)
        } else{
            PostRepository.shared.removePost(post)
            if(savedActive) {
                PostRepository.shared.data = PostRepository.shared.dataSaved
                scrollUp()
            }
        }
        post.isSaved.toggle()
        postTable.reloadData()
        PostRepository.shared.savePostsBeforeExit()
    }
    
    func loadSavedData(){
        PostRepository.shared.loadSavedPosts()
    }
    
    func shouldShare(post: Post) {
        let items = [post.link]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    
}


//extension UIColor{
//    func inverseColor() -> UIColor {
//        var alpha: CGFloat = 1.0
//
//        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
//        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
//            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
//        }
//
//        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
//        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
//            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
//        }
//
//        var white: CGFloat = 0.0
//        if self.getWhite(&white, alpha: &alpha) {
//            return UIColor(white: 1.0 - white, alpha: alpha)
//        }
//
//        return self
//    }
//}





