//
//  NavViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 22.02.2022.
//

import UIKit


class NavViewController: UIViewController {

    var gainedData: Post = Post()
    weak var delegate: TableViewController?
    
    @IBAction func buttonPress(_ sender: UIButton) {
        gainedData.isSaved.toggle()
        self.bookmark.setImage(gainedData.isSaved ? UIImage(systemName: "bookmark")! : UIImage(systemName: "bookmark.fill")!, for: .normal)
        delegate.self?.saveData(post: gainedData)
    }
    
    @IBAction func share(_ sender: Any) {
        let items = [gainedData.link]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var comments: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var user: UILabel!
    @IBOutlet private weak var bookmark: UIButton!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var thread: UILabel!
    @IBOutlet private weak var titlePost: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rating.text = "\(gainedData.rating)"
        self.comments.text = "\(gainedData.comments)"
        self.user.text = gainedData.username
        self.time.text = gainedData.time
        self.thread.text = gainedData.domain
        self.titlePost.text = gainedData.title
        gainedData.isSaved ? self.bookmark.setImage(UIImage(systemName: "bookmark.fill")!, for: .normal) : self.bookmark.setImage(UIImage(systemName: "bookmark")!, for: .normal)
        if let url = gainedData.image{
            self.image.load(url: URL(string: url)!)
        }
        else {
            self.image.image = UIImage(named: "NoImage")!
        }
        
    }
    
}
