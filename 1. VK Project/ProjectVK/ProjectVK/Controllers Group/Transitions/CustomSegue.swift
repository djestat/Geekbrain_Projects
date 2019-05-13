//
//  CustomSegue.swift
//  ProjectVK
//
//  Created by Igor on 11/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    let animationDuration: TimeInterval = 0.75
    
    override func perform() {
        guard let containerView = source.view else { return }
        
        containerView.addSubview(destination.view)
        source.view.frame = containerView.frame
        destination.view.frame = containerView.frame
        destination.view.alpha = 0
    
        
        destination.view.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.destination.view.alpha = 1.0
            self.destination.view.transform = .identity
        }, completion: { finished in
            self.source.present(self.destination, animated: false)
        })
    }
    
}
