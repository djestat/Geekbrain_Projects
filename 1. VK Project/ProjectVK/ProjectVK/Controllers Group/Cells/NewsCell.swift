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
    public var aspectRatio: CGFloat = 0.2
    public var photoWidth: CGFloat = 375
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var newsPhotosView: UIImageView!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountsLabel: UILabel!
    @IBOutlet weak var commentsCountsLabel: UILabel!
    @IBOutlet weak var viewsIcon: UIImageView!
    @IBOutlet weak var viewsCountsLabel: UILabel!
    @IBOutlet weak var documentSubview: UIView!
    @IBOutlet weak var documentLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        setImageSize()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
//        Если вы хотите принудительно обновить макет, вместо этого вызовите метод setNeedsLayout (), чтобы сделать это до следующего обновления чертежа.
//        setImageSize()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
//        Если вы хотите немедленно обновить макет ваших представлений, вызовите метод layoutIfNeeded ().
        setImageSize()
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
    
    func setImageSize() {
        let width = self.photoWidth
        let heightNewsImage = width * aspectRatio
        newsPhotosView.autoresizingMask = .flexibleHeight
        newsPhotosView.frame.size = CGSize(width: width, height: heightNewsImage)
    }

}
