//
//  NewsCell.swift
//  ProjectVK
//
//  Created by Igor on 20/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    static let reuseID = "NewsCell"
    public var aspectRatio: CGFloat = 1
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var newsPhotosView: UIImageView! {
        didSet {
            newsPhotosView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var newsTextLabel: UITextView!
    @IBOutlet weak var likeCountsLabel: UILabel!
    @IBOutlet weak var commentsCountsLabel: UILabel!
    @IBOutlet weak var viewsIcon: UIImageView!
    @IBOutlet weak var viewsCountsLabel: UILabel!
    @IBOutlet weak var documentSubview: UIView!
    @IBOutlet weak var documentLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        animationTappedPhoto()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animationTappedPhoto() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        newsPhotosView.isUserInteractionEnabled = true
        newsPhotosView.addGestureRecognizer(tapGR)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // handling code
            self.newsPhotosView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
            UIView.animate(withDuration: 0.75,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 5,
                           options: .curveEaseInOut,
                           animations: {
                            self.newsPhotosView.transform = .identity
            },
                           completion: nil)
        }
    }

}
