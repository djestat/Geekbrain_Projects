//
//  FriendsBigPhotoCell.swift
//  ProjectVK
//
//  Created by Igor on 10/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class FriendsBigPhotoCell: UICollectionViewCell {
    static let reuseID = "FriendsBigPhotoCell"
    
    @IBOutlet weak var bigFriendPhoto: UIImageView!
    
    override func awakeFromNib() {
      
    }
    
    /*
    //not used ---------------
    func animationTappedPhoto() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        bigFriendPhoto.isUserInteractionEnabled = true
        bigFriendPhoto.addGestureRecognizer(tapGR)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state != .began {
            // handling code
            self.bigFriendPhoto.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } else if sender.state == .ended {
            self.bigFriendPhoto.transform = .identity
        }
        
        switch sender.state {
        case .began:
            print("begin")
        case .cancelled:
            print("cancel")
        case .changed:
            print("change")
        case .ended:
            print("ended")
        case .possible:
            print("possible")
        default:
            print("XZ")
        }
    } */
    
}
