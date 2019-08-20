//
//  NewsCell.swift
//  ProjectVK
//
//  Created by Igor on 20/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class GroupNewsCell: UITableViewCell {
    
    static let reuseID = "GroupNewsCell"
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
//        Если вы хотите принудительно обновить макет, вместо этого вызовите метод setNeedsLayout (), чтобы сделать это до следующего обновления чертежа.
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
//        Если вы хотите немедленно обновить макет ваших представлений, вызовите метод layoutIfNeeded ().
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class TextNewsCell: UITableViewCell {
    
    static let reuseID = "TextNewsCell"
    
    @IBOutlet weak var newsTextLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

class ContentNewsCell: UITableViewCell {
    
    static let reuseID = "ContentNewsCell"
    
    @IBOutlet weak var newsPhotosView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        //        Если вы хотите принудительно обновить макет, вместо этого вызовите метод setNeedsLayout (), чтобы сделать это до следующего обновления чертежа.
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        //        Если вы хотите немедленно обновить макет ваших представлений, вызовите метод layoutIfNeeded ().
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        animationTappedPhoto()
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

class ActivitiesNewsCell: UITableViewCell {
    
    static let reuseID = "ActivitiesNewsCell"
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountsLabel: UILabel!
    @IBOutlet weak var commentsCountsLabel: UILabel!
    @IBOutlet weak var viewsIcon: UIImageView!
    @IBOutlet weak var viewsCountsLabel: UILabel!

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
