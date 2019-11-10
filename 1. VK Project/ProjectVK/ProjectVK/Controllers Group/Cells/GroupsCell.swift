//
//  GroupsCell.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsCell: UITableViewCell {
    
    static let reuseID = "GroupsCell"
    
    @IBOutlet var groupName: UILabel!
    @IBOutlet var groupPhoto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: GroupCellModel) {
        groupName.text = viewModel.groupName
        groupPhoto.kf.setImage(with: URL(string: viewModel.groupPhoto))
    }

}
