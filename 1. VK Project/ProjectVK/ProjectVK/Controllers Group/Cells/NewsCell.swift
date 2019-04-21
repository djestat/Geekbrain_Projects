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
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var newsPhotosView: UIImageView!
    @IBOutlet weak var likeCountsLabel: UILabel!
    @IBOutlet weak var commentsCountsLabel: UILabel!
    @IBOutlet weak var viewsCountsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupNameLabel.text = "Goose"
        newsPhotosView.image = UIImage(named: "goose")
        likeCountsLabel.text = String(98765)
        commentsCountsLabel.text = String(976)
        viewsCountsLabel.text = String(235)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
