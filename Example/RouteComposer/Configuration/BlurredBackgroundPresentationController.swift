//
// Created by Eugene Kazaev on 10/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

enum BlurredBackgroundTransitionType {
    case present
    case dismiss
}

class BlurredBackgroundPresentationController: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BlurredBackgroundTransitionAnimator(transitionType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BlurredBackgroundTransitionAnimator(transitionType: .dismiss)
    }
    
}

class BlurredBackgroundTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let transitionType: BlurredBackgroundTransitionType
    
    init(transitionType: BlurredBackgroundTransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    private func blurEffectView(_ style: UIBlurEffect.Style = .light, frame: CGRect? = nil, backgroundColor: UIColor?) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        if let frame = frame {
            blurEffectView.frame = frame
        }
        blurEffectView.backgroundColor = backgroundColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }
    
    private func stretchToView(_ view: UIView, to containerView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
              let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let viewControllerToAnimate = transitionType == .present ? toViewController : fromViewController
        let initialAlpha: CGFloat = transitionType == .present ? 0 : 1
        let finalAlpha: CGFloat = transitionType == .present ? 1 : 0
        
        let backgroundColor = UIColor.white
        let blurEffect = blurEffectView(backgroundColor: backgroundColor)
        transitionContext.containerView.addSubview(blurEffect)
        transitionContext.containerView.sendSubviewToBack(blurEffect)
        stretchToView(blurEffect, to: transitionContext.containerView)
        let effect: UIBlurEffect? = transitionType == .present ? UIBlurEffect(style: .extraLight) : nil
        blurEffect.alpha = initialAlpha
        
        transitionContext.containerView.addSubview(viewControllerToAnimate.view)
        viewControllerToAnimate.view.frame = UIScreen.main.bounds
        viewControllerToAnimate.view.alpha = initialAlpha
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext) / 2.0,
                delay: transitionDuration(using: transitionContext) / 2.0,
                options: .curveEaseIn,
                animations: {
                    blurEffect.effect = effect
                    blurEffect.alpha = finalAlpha
                }, completion: nil)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            viewControllerToAnimate.view.alpha = finalAlpha
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
}
