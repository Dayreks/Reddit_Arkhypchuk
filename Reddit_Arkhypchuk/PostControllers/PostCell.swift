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
    
    @IBOutlet private weak var postView: PostView!
    
    weak var delegate: PostCellDelagate?
    
    
    func configureView(post: inout Post) {
        postView.confirgureView(post: &post, delegate: delegate!)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            //postView.gestureRecognizers?.forEach(postView.removeGestureRecognizer(_:))
        }
}
