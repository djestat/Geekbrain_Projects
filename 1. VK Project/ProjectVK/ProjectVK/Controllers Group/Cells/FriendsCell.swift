//
//  FriendsCell.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

//@IBDesignable
class FriendsCell: UITableViewCell {
    
    static let reuseID = "FriendsCell"
    
    @IBOutlet var friendName: UILabel!
    @IBOutlet var friendPhoto: UIImageView!
    
    //Shadow layer 
    var avatarShadowSublayer = CAShapeLayer()
    
//    @IBInspectable
    var shadowRadius: CGFloat = 10
//    @IBInspectable
    var shadowColor: UIColor = .purple
//    @IBInspectable
    var shadowOpacity: Float = 0.95
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        configureMask()
        configureShadow()
    }
    
    
    
    // MARK: - Layers configure
    
    func configureMask() {
        friendPhoto.layer.cornerRadius = friendPhoto.frame.height / 2
        friendPhoto.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.RawValue.init(bitPattern: 7))
        friendPhoto.layer.masksToBounds = true
        
    }
    
    func configureShadow() {
        
        avatarShadowSublayer.backgroundColor = UIColor.white.cgColor
        avatarShadowSublayer.path = UIBezierPath(roundedRect: friendPhoto.layer.frame, byRoundingCorners: [.bottomLeft, .topLeft, .topRight], cornerRadii: CGSize(width: friendPhoto.frame.height / 2, height: friendPhoto.frame.height / 2)).cgPath
        
        avatarShadowSublayer.shadowColor = shadowColor.cgColor
        avatarShadowSublayer.shadowPath = avatarShadowSublayer.path
        avatarShadowSublayer.shadowOffset = .zero
        avatarShadowSublayer.shadowOpacity = shadowOpacity
        avatarShadowSublayer.shadowRadius = shadowRadius
        
        layer.insertSublayer(avatarShadowSublayer, at: 0)
        
    }
    
}
