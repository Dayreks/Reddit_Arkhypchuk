//
//  NavViewController.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 22.02.2022.
//

import UIKit
import SwiftUI


class NavViewController: UIViewController {
    
    var gainedData: Post = Post()
    weak var delegate: PostCellDelagate?
    
    @IBOutlet private weak var commentsContainer: UIView!
    @IBOutlet weak var navbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        loadCommentsView()
    }
    
    func loadCommentsView(){
        let hostingVC = UIHostingController(rootView: CommentsTable(post: gainedData, delegate: delegate!).environmentObject(ModelData(subreddit: "ios", id: gainedData.id)))
        
        self.addChild(hostingVC)
        self.commentsContainer.addSubview(hostingVC.view)
        hostingVC.didMove(toParent: self)
        
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        hostingVC.view.topAnchor.constraint(equalTo: commentsContainer.topAnchor).isActive = true
        hostingVC.view.trailingAnchor.constraint(equalTo: commentsContainer.trailingAnchor).isActive = true
        hostingVC.view.leadingAnchor.constraint(equalTo: commentsContainer.leadingAnchor).isActive = true
        hostingVC.view.bottomAnchor.constraint(equalTo: commentsContainer.bottomAnchor).isActive = true
        
    }
}
