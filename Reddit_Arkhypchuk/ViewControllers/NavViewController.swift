//
//  NavViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 22.02.2022.
//

import UIKit

class NavViewController: UIViewController {

    var gainedData: Post = Post()
    
    
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
        if let url = gainedData.image{
            self.image.load(url: URL(string: url)!)
        }
        else {
            self.image.image = UIImage(named: "NoImage")!
        }
    }
    
}
