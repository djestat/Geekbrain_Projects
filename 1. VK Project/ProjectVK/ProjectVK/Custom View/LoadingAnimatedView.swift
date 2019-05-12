//
//  LoadingAnimatedView.swift
//  ProjectVK
//
//  Created by Igor on 06/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class LoadingAnimatedView: UIView {
    
    @IBOutlet weak var dotView1: UIView?
    @IBOutlet weak var dotView2: UIView?
    @IBOutlet weak var dotView3: UIView?
    @IBOutlet weak var loadingLabel: UILabel?
    
    private func configureViews() {
        
//        dotView1?.backgroundColor = .clear
        dotView1?.alpha = 0
        dotView1?.clipsToBounds = true
//        dotView2?.backgroundColor = .clear
        dotView1?.alpha = 0
        dotView2?.clipsToBounds = true
//        dotView3?.backgroundColor = .clear
        dotView1?.alpha = 0
        dotView3?.clipsToBounds = true
//        loadingLabel?.textColor = .clear
        

    }
    
    override func layoutSubviews() {
        
//        configureViews()
        
        let dotCornerRaduis: CGFloat = 25 / 2
        
        dotView1?.layer.cornerRadius = dotCornerRaduis
        dotView2?.layer.cornerRadius = dotCornerRaduis
        dotView3?.layer.cornerRadius = dotCornerRaduis
        
        startLoadingAnimation()
//        stopAnimation()
    }
    
    public func startLoadingAnimation() {
        
//        dotView1?.backgroundColor = .gray
//        dotView2?.backgroundColor = .gray
//        dotView3?.backgroundColor = .gray
//        loadingLabel?.textColor = .gray
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.autoreverse, .curveEaseInOut, .repeat], animations: {
            self.dotView1?.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.15, options: [.autoreverse, .curveEaseInOut, .repeat], animations: {
            self.dotView2?.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.3, options: [.autoreverse, .curveEaseInOut, .repeat], animations: {
            self.dotView3?.alpha = 0
        }, completion: nil)
    }
    
    public func stopAnimation() {
        dotView1?.layer.removeAllAnimations()
        dotView2?.layer.removeAllAnimations()
        dotView3?.layer.removeAllAnimations()
        loadingLabel?.layer.removeAllAnimations()
    }
}
