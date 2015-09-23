//
//  Animations.swift
//  Game Replay
//
//  Created by Daniel Drake on 9/15/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit

class Animations: NSObject {
    
    func bounceView(view: UIView) {
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            }, completion: nil)
        UIView.animateWithDuration(0.4,
            delay: 0.1,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
    }
    
    func growView(view: UIView, duration: NSTimeInterval) {
        
        UIView.animateWithDuration(duration,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
    }
    
    func bounceInOut(view: UIView){
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.frame.origin.x = -65
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 5.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.frame.origin.x = -280
            }, completion: nil)
    }
    
    func transformViewToClose(viewToClose: UIView, viewToOpen: UIView, viewToHide: UIView) {
        
        UIView.animateWithDuration(0.2,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                viewToClose.transform = CGAffineTransformMakeScale(0.0, 0.0)
            }, completion: nil)
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                viewToOpen.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
        UIView.animateWithDuration(0.1,
            delay: 1.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                viewToHide.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
            }, completion: nil)
    }
    
    func animateTransformToZero(view: UIView) {
        
        UIView.animateWithDuration(0.1,
        delay: 0.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: {
        view.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
        }, completion: nil)
    }

    func close(view: UIView){
        
        UIView.animateWithDuration(0.2,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.transform = CGAffineTransformMakeScale(0.0, 0.0)
            }, completion: nil)
    }
    
    func open(view: UIView) {
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
    }
    
    
    
}
