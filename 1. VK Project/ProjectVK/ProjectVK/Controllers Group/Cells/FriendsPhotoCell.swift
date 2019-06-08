//
//  GroupsCell.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class FriendsPhotoCell: UICollectionViewCell {
    
    static let reuseID = "FriendsPhotoCell"
    
    public var likeToggle: Bool = false
    public var isLiked: Int = 0
    public var likeCounts: Int = 0
    
    @IBOutlet var likedImage: UIImageView!
    @IBOutlet var likeCountsLabel: UILabel!
    
    @IBOutlet var friendProfilePhoto: UIImageView!
    
    override func awakeFromNib() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likedImage.isUserInteractionEnabled = true
        likedImage.addGestureRecognizer(tapGR)
        
        likeCountsLabel.text = String(likeCounts)
        
        if isLiked == 1 {
            likedImage.image = UIImage(named: "Like_fill")
            likeCountsLabel.textColor = .red
        } else {
            likedImage.image = UIImage(named: "Like_nonfill")
            likeCountsLabel.textColor = .black
        }
        
        
    }
    
    
   
    @objc func likeTapped() {
        likeToggle.toggle()
        if likeToggle == true {
            UIView.transition(with: likedImage, duration: 0.45, options: .transitionCurlUp, animations: {
                self.likedImage.image = UIImage(named: "Like_fill")
            }) { _ in
                self.likeCounts += 1
                self.likeCountsLabel.text = String(self.likeCounts)
                self.likeCountsLabel.textColor = .red
            }
        } else {
            UIView.transition(with: likedImage, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.likedImage.image = UIImage(named: "Like_nonfill")
            }) { _ in
                self.likeCounts -= 1
                self.likeCountsLabel.text = String(self.likeCounts)
                self.likeCountsLabel.textColor = .black

            }
        }
        
    }
    
    
}
