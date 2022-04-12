//
//  PostCell.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 21.02.2022.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    
    var isOn: Bool = false
    @IBAction func buttonPress(_ sender: UIButton) {
        isOn.toggle()
        setButtonBackGround(view: sender, on: UIImage(systemName: "bookmark")!, off:  UIImage(systemName: "bookmark.fill")!, onOffStatus: isOn)
    }
    func setButtonBackGround(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool ) {
         switch onOffStatus {
              case true:
                   view.setImage(on, for: .normal)
              default:
                   view.setImage(off, for: .normal)
    }
    }
    
    @IBOutlet private weak var imagePost: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var thread: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var bookmark: UIButton!
    @IBOutlet private weak var user: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var comments: UILabel!
    
    func configureView(post: Post) {
        self.rating.text = "\(post.rating)"
        self.comments.text = "\(post.comments)"
        self.user.text = post.username
        self.time.text = post.time
        self.thread.text = post.domain
        self.title.text = post.title
        if let url = post.image{
            self.imagePost.load(url: URL(string: url)!)
        }
        else {
            self.imagePost.image = UIImage(named: "NoImage")!
        }
        
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
