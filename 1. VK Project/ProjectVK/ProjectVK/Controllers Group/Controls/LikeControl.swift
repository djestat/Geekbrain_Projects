//
//  LikeControl.swift
//  ProjectVK
//
//  Created by Igor on 15/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    
    public var isLiked: Bool = false
    public var likeCounts = 0
    
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
        likeControlView.image = UIImage(named: "Like_nonfill")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        likeControlView.frame = bounds
        likeCount.text = String(likeCounts)
    }
    
    //MARK: - Extended Functionn
    @objc func likeTapped() {
        isLiked.toggle()
        if isLiked == true {
            UIView.transition(with: likeControlView, duration: 0.45, options: .transitionCurlUp, animations: {
                self.likeControlView.image = UIImage(named: "Like_fill")
            }) { _ in
                self.likeCounts += 1
                self.likeCount.text = String(self.likeCounts)
            }
        } else {
            UIView.transition(with: likeControlView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.likeControlView.image = UIImage(named: "Like_nonfill")
            }) { _ in
                self.likeCounts -= 1
                self.likeCount.text = String(self.likeCounts)
            }
        }
        
    }
}
