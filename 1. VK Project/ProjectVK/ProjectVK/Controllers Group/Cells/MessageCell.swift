//
//  MessageCell.swift
//  ProjectVK
//
//  Created by Igor on 08/08/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    static let reuseID = "MessageCell"
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        TextViewConfigure()
    }
    
    func TextViewConfigure() {
        let cornerRadius: CGFloat = 10
        messageView.layer.cornerRadius = cornerRadius
        messageView.layer.opacity = Float(cornerRadius - CGFloat(5))
//        messageView.backgroundColor = .darkGray
        
//        messageTextLabel.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.RawValue.init(bitPattern: 7))
//        messageTextLabel.layer.masksToBounds = true
    }

}
