//
//  CustomPushAnimatro.swift
//  ProjectVK
//
//  Created by Igor on 11/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration: TimeInterval = 0.75
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = transitionContext.containerView.frame
        destination.view.transform = CGAffineTransform(translationX: source.view.bounds.width, y: -source.view.bounds.height)
        
        UIView.animate(withDuration: animationDuration, animations: {
            destination.view.transform = .identity
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
        
    }
}

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration: TimeInterval = 0.75
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.layer.position = CGPoint(x: source.view.bounds.width, y: 0)
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        
        UIView.animate(withDuration: animationDuration, animations: {
            destination.view.transform = .identity
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)        })
    }
}

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration: TimeInterval = 0.75
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        
        UIView.animate(withDuration: animationDuration, animations: {
            source.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
        
        
    }
}
