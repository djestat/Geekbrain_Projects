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
    var shadowRadius: CGFloat = 8
//    @IBInspectable
    public var shadowColor: UIColor = .darkGray
//    @IBInspectable
    var shadowOpacity: Float = 0.95
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Animation not do here
//        UIView.animate(withDuration: 0.6, delay: 0.3, animations: {
//            self.friendPhoto.bounds = CGRect(x: 0, y: 0, width: 500, height: 500)
//            self.friendName.bounds = CGRect(x: 0, y: 0, width: 500, height: 500)
//        })
        
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
        friendPhoto.layer.cornerRadius = friendPhoto.frame.height / 2.1
        friendPhoto.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.RawValue.init(bitPattern: 7))
        friendPhoto.layer.masksToBounds = true
    }
    
    func configureShadow() {
        avatarShadowSublayer.backgroundColor = UIColor.white.cgColor
        avatarShadowSublayer.fillColor = UIColor.lightGray.cgColor
//        avatarShadowSublayer.strokeColor = UIColor.lightGray.cgColor
        avatarShadowSublayer.path = UIBezierPath(roundedRect: friendPhoto.layer.frame, byRoundingCorners: [.bottomLeft, .topLeft, .topRight], cornerRadii: CGSize(width: friendPhoto.frame.height / 2, height: friendPhoto.frame.height / 2)).cgPath
        
        avatarShadowSublayer.shadowColor = shadowColor.cgColor
        avatarShadowSublayer.shadowPath = avatarShadowSublayer.path
        avatarShadowSublayer.shadowOffset = .zero
        avatarShadowSublayer.shadowOpacity = shadowOpacity
        avatarShadowSublayer.shadowRadius = shadowRadius
        
        contentView.layer.insertSublayer(avatarShadowSublayer, at: 1)
        
    }
    
}
