//
//  FriendsCell.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

@IBDesignable class FriendsCell: UITableViewCell {
    
    static let reuseID = "FriendsCell"
    
    @IBOutlet var friendName: UILabel!
    @IBOutlet var friendPhoto: UIImageView!
    
    //Shadow layer 
    var avatarShadowSublayer = CAShapeLayer()
    @IBInspectable var shadowRadius: CGFloat = 6
    @IBInspectable var shadowColor: UIColor = .clear
    @IBInspectable var shadowOpacity: Float = 0.85
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureMask()
        configureShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Layers configure
    
    func configureMask() {
        friendPhoto.layer.cornerRadius = friendPhoto.frame.height / 2
        friendPhoto.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.RawValue.init(bitPattern: 7))
        friendPhoto.layer.masksToBounds = true
    }
    
    func configureShadow() {
        
//        avatarShadowSublayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
//        avatarShadowSublayer.path = UIBezierPath(roundedRect: friendPhoto.layer.contentsRect, cornerRadius: 6).cgPath
//        avatarShadowSublayer.path = UIBezierPath(rect: friendPhoto.layer.frame).cgPath
        avatarShadowSublayer.path = UIBezierPath(roundedRect: friendPhoto.layer.frame, cornerRadius: friendPhoto.frame.height).cgPath
        
        avatarShadowSublayer.shadowColor = shadowColor.cgColor
        avatarShadowSublayer.shadowPath = avatarShadowSublayer.path
        avatarShadowSublayer.shadowOffset = .zero
        avatarShadowSublayer.shadowOpacity = shadowOpacity
        avatarShadowSublayer.shadowRadius = shadowRadius

        layer.insertSublayer(avatarShadowSublayer, at: 0)
        
    }
    
}
