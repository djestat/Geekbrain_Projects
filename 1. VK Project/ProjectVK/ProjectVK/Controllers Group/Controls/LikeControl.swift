//
//  LikeControl.swift
//  ProjectVK
//
//  Created by Igor on 15/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    
    public var isLike: Bool = false
    
    var likeCounts = 110
    let likeControlView = UIImageView()
    
    @IBOutlet var likeCount: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeControlView.isUserInteractionEnabled = true
        likeControlView.addGestureRecognizer(tapGR)
            
        addSubview(likeControlView)
        likeControlView.image = UIImage(named: "nonLike")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        likeControlView.frame = bounds
        likeCount.text = String(likeCounts)
    }
    
    //MARK: - Extended Functionn
    @objc func likeTapped() {
        isLike.toggle()
        if isLike == true {
            likeControlView.image = UIImage(named: "Like")
            likeCount.text = String(likeCounts + 1)
        } else {
            likeControlView.image = UIImage(named: "nonLike")
            likeCount.text = String(likeCounts)
        }
        
    }
}
