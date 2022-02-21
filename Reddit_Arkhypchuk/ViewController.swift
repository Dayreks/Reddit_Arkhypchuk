//
//  ViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 15.02.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet private weak var titlePost: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var thread: UILabel!
    @IBOutlet private weak var hours: UILabel!
    @IBOutlet private weak var user: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var comments: UILabel!
    @IBOutlet private weak var bookmark: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emptyData = ParsedData()
        emptyData.fetchData(subreddit: "ios", limit: 1, after: ""){ postData in
            DispatchQueue.main.async {
                self.rating.text = "\(postData.posts[0].rating)"
                self.comments.text = "\(postData.posts[0].comments)"
                self.user.text = postData.posts[0].username
                self.hours.text = postData.posts[0].time
                self.thread.text = postData.posts[0].domain
                self.titlePost.text = postData.posts[0].title
                if let url = postData.posts[0].image{
                    self.image.load(url: URL(string: url)!)
                }
                else {
                    self.image.load(url: URL(string: "https://st2.depositphotos.com/1009634/7235/v/450/depositphotos_72350117-stock-illustration-no-user-profile-picture-hand.jpg?forcejpeg=true")!)
                }
            }
        }
        
    }
}

