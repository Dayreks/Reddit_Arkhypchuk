//
//  PostView.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 18.04.2022.
//

import UIKit
import AVFoundation

class PostView: UIView {
    let kCONTENT_XIB_NAME = "PostView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var thread: UILabel!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var upvotes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var share: UIButton!
    
    private var shape: CAShapeLayer?
    private var tapGesture: UITapGestureRecognizer!
    private weak var delegate: PostCellDelagate?
    var post: Post?
    
    //MARK: Button Actions
    
    @IBAction func buttonPress(_ sender: UIButton) {
        guard var verifiedPost = post else {
            print("Save error: Post is nil!")
            return
        }
        delegate?.saveData(post: &verifiedPost)
        post!.isSaved ? self.bookmark.setImage(UIImage(systemName: "bookmark.fill")!, for: .normal) : self.bookmark.setImage(UIImage(systemName: "bookmark")!, for: .normal)
    }
    
    @IBAction func share(_ sender: Any) {
        guard let verifiedPost = post else {
            print("Share error: Post is nil!")
            return
        }
        delegate?.shouldShare(post: verifiedPost)
    }
    
    @objc func gestureAction() {
        guard let verifiedPost = post else {
            print("Animation error: Post is nil!")
            return
        }
        shape!.fillColor = verifiedPost.isSaved ? UIColor.clear.cgColor : UIColor.systemBlue.cgColor

        let disappearingAnimation = CABasicAnimation(keyPath: "opacity")
        disappearingAnimation.fromValue = 1
        disappearingAnimation.toValue = 0
        disappearingAnimation.duration = 0.5
        disappearingAnimation.beginTime = CACurrentMediaTime() + 0.1
        self.shape?.add(disappearingAnimation, forKey: nil)

        buttonPress(bookmark)
    }
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.image.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        self.shape = self.animationPath()
        self.image.layer.addSublayer(self.shape!)
    }
    
    //MARK: Configuration
    
    func confirgureView(post: inout Post, delegate: PostCellDelagate?){
        self.delegate = delegate
        self.post = post
        self.upvotes.text = "\(post.rating)"
        self.comments.text = "\(post.comments)"
        self.user.text = post.username
        self.time.text = post.time
        self.thread.text = post.domain
        self.title.text = post.title
        post.isSaved ? self.bookmark.setImage(UIImage(systemName: "bookmark.fill")!, for: .normal) : self.bookmark.setImage(UIImage(systemName: "bookmark")!, for: .normal)
        if let url = post.image{
            self.image.sd_setImage(with: URL(string: url))
        }
        else {
            self.image.image = UIImage(named: "NoImage")!
        }

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        self.tapGesture.numberOfTapsRequired = 2
        self.tapGesture.delaysTouchesBegan = true

        
        self.image.gestureRecognizers?.forEach { self.image.removeGestureRecognizer($0) }
        self.image.addGestureRecognizer(self.tapGesture)

        if let shape = shape {
            shape.fillColor = post.isSaved ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        }
    }
    
    private func animationPath() -> CAShapeLayer{
        
        let radius: CGFloat = 30
        let path = UIBezierPath()

        path.move(to: CGPoint(x: image.frame.midX - radius/2,
                              y: image.frame.midY - image.frame.minY - radius))
        path.addLine(to: CGPoint(x: image.frame.midX + radius/2,
                                 y: (image.frame.maxY - image.frame.minY)/2 - radius))
        path.addLine(to: CGPoint(x: image.frame.midX + radius/2,
                                 y: (image.frame.maxY - image.frame.minY)/2 + radius))
        path.addLine(to: CGPoint(x: image.frame.midX,
                                 y: (image.frame.maxY - image.frame.minY)/2 + radius / 3))
        path.addLine(to: CGPoint(x: image.frame.midX - radius/2,
                                 y: (image.frame.maxY - image.frame.minY)/2 + radius))
        path.addLine(to: CGPoint(x: image.frame.midX - radius/2,
                                 y: (image.frame.maxY - image.frame.minY)/2 - radius))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.opacity = 0.85
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeLayer.lineWidth = 3

        shapeLayer.opacity = 0
        shapeLayer.zPosition = .greatestFiniteMagnitude
        
        return shapeLayer
    }

}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
