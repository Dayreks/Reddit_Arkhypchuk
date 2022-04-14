//
//  PostCell.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 21.02.2022.
//

import Foundation
import UIKit
import SDWebImage

protocol PostCellDelagate: AnyObject{
    func shouldShare(post: Post)
    func saveData(post: inout Post)
    func loadSavedData()
}

class PostCell: UITableViewCell {
    
    weak var delegate: PostCellDelagate?
    
    @IBAction func buttonPress(_ sender: UIButton) {
        delegate.self?.saveData(post: &post)
    }
    
    @IBAction func share(_ sender: Any) {
        delegate.self?.shouldShare(post: post)
    }
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet private weak var imagePost: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var thread: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var bookmark: UIButton!
    @IBOutlet private weak var user: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var comments: UILabel!
    
    private var post = Post()
    
    func configureView(post: Post) {
        self.post = post
        self.rating.text = "\(post.rating)"
        self.comments.text = "\(post.comments)"
        self.user.text = post.username
        self.time.text = post.time
        self.thread.text = post.domain
        self.title.text = post.title
        post.isSaved ? self.bookmark.setImage(UIImage(systemName: "bookmark.fill")!, for: .normal) : self.bookmark.setImage(UIImage(systemName: "bookmark")!, for: .normal)
        if let url = post.image{
            self.imagePost.sd_setImage(with: URL(string: url))
        }
        else {
            self.imagePost.image = UIImage(named: "NoImage")!
        }
        
    }
    
}
