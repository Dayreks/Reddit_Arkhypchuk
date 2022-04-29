//
//  NavViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 22.02.2022.
//

import UIKit


class NavViewController: UIViewController {

    var gainedData: Post = Post()
    weak var delegate: PostCellDelagate?
    
    @IBOutlet weak var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.title.numberOfLines = 3
        postView.confirgureView(post: &gainedData, delegate: delegate!)
    }
    
}
