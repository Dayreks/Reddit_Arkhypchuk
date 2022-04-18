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
        delegate?.saveData(post: &gainedData)
        gainedData.isSaved ? self.bookmark.setImage(UIImage(systemName: "bookmark.fill")!, for: .normal) : self.bookmark.setImage(UIImage(systemName: "bookmark")!, for: .normal)
    }
    
    @IBAction func share(_ sender: Any) {
        let items = [gainedData.link]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    @objc func gestureAction() {
        delegate?.animation(in: image, post: gainedData)
        buttonPress(bookmark)
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
            self.image.sd_setImage(with: URL(string: url))
        }
        else {
            self.image.image = UIImage(named: "NoImage")!
        }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(gestureAction))
        tapGesture.numberOfTapsRequired = 2
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)
        
    }
    
}
