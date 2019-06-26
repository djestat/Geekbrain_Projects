//
//  MessagesCell.swift
//  ProjectVK
//
//  Created by Igor on 24/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    static let reuseID = "MessagesCell"
    
    @IBOutlet weak var chatOwnerImageView: UIImageView!
    @IBOutlet weak var chatOwnerNameLabel: UILabel!
    @IBOutlet weak var chatLastMessageLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
