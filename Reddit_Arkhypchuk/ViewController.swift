//
//  ViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 15.02.2024.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var thread: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var bookmark: UIButton!
    
    var isOn: Bool = false
    @IBAction func buttonPress(_ sender: UIButton) {
    isOn.toggle()
        setButtonBackGround(view: sender, on: UIImage(named: "Mark")!, off:  UIImage(named: "UnMark")!, onOffStatus: isOn)
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
                self.rating.text = "\(postData.rating)"
                self.comments.text = "\(postData.comments)"
                self.user.text = postData.username
                self.hours.text = postData.time
                self.thread.text = postData.domain
                self.titlePost.text = postData.title
                if let url = postData.image{
                    self.image.load(url: URL(string: url)!)
                }
                else {
                    self.image.load(url: URL(string: "https://st2.depositphotos.com/1009634/7235/v/450/depositphotos_72350117-stock-illustration-no-user-profile-picture-hand.jpg?forcejpeg=true")!)
                }
            }
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
