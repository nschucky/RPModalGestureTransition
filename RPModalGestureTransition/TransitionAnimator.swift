//
//  TransitionAnimator.swift
//  RPModalGestureTransition
//
//  Created by naoyashiga on 2015/09/28.
//  Copyright © 2015年 naoyashiga. All rights reserved.
//

import UIKit

enum GestureDirection {
    case Up, Down
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private(set) weak var transitionContext: UIViewControllerContextTransitioning?
    
    private var containerView: UIView? {
        return transitionContext?.containerView()
    }
    
    private var toViewController: UIViewController? {
        return transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
    }
    
    private var fromViewController: UIViewController? {
        return transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
    }
    
    private var toView: UIView? {
        return transitionContext?.viewForKey(UITransitionContextToViewKey)
    }
    
    private var fromView: UIView? {
        return transitionContext?.viewForKey(UITransitionContextFromViewKey)
    }
    
    private let isPresenting :Bool
    private let gestureDirection :GestureDirection
    private let animationDuration: NSTimeInterval = 1.0
    
    init(isPresenting: Bool, gestureDirection :GestureDirection = .Up) {
        self.isPresenting = isPresenting
        self.gestureDirection = gestureDirection
        
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        if isPresenting {
            
            prepareViews()
            
            animatePresentationWithTransitionContext()
            
        } else {
            animateDismissalWithTransitionContext()
        }
    }
    
    private func prepareViews() {
        guard let transitionContext = transitionContext, toViewController = toViewController, containerView = containerView, toView = toView else {
            return
        }
        
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        containerView.addSubview(toView)
    }
    
    private func animatePresentationWithTransitionContext() {
        
        layoutBeforePresentation()
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: layoutAfterPresentation,
            completion: didFinishedAnimation
        )
    }
    
    private func animateDismissalWithTransitionContext() {
        
        layoutBeforeDismissal()
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: layoutAfterDismissal,
            completion: didFinishedAnimation
        )
    }
    
    private func didFinishedAnimation(_:Bool) {
        guard let transitionContext = transitionContext else {
            return
        }
        
        if transitionContext.transitionWasCancelled() {
            transitionContext.completeTransition(false)
        } else {
            transitionContext.completeTransition(true)
        }
    }
    
    private func layoutBeforePresentation() {
        guard let toView = toView else {
            return
        }
        
        toView.center.y -= toView.frame.size.height
    }
    
    private func layoutAfterPresentation() {
        guard let toView = toView else {
            return
        }
        
        toView.center.y += UIScreen.mainScreen().bounds.size.height / 2
    }
    
    private func layoutBeforeDismissal() {
        // layoutBeforeDismissal
    }
    
    private func layoutAfterDismissal() {
        guard let fromView = fromView else {
            return
        }
        
        switch gestureDirection {
        case .Up:
            fromView.center.y = -fromView.bounds.height / 2
            
        case .Down:
            fromView.center.y = UIScreen.mainScreen().bounds.size.height + fromView.bounds.height / 2
        }
    }
}
