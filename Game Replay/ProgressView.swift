//
//  ProgressView.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/10/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.


import UIKit

class ProgressView: UIView {
    
    private let progressLayer: CAShapeLayer = CAShapeLayer()
    
    private var progressLabel: UILabel
    
    var gradientLayer: CAGradientLayer!
    
    required init?(coder aDecoder: NSCoder) {
        progressLabel = UILabel()
        super.init(coder: aDecoder)
        createProgressLayer()
        createLabel()
    }
    
    override init(frame: CGRect) {
        progressLabel = UILabel()
        super.init(frame: frame)
        createProgressLayer()
        createLabel()
    }
    
    func createLabel() {
        progressLabel = UILabel(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 60.0))
        progressLabel.textColor = .whiteColor()
        progressLabel.textAlignment = .Center
        progressLabel.text = "Load content"
        progressLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    private func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        
        let gradientMaskLayer = gradientMask()
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 30.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.blackColor().CGColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        
        gradientMaskLayer.mask = progressLayer
        layer.addSublayer(gradientMaskLayer)
    }
    
    private func gradientMask() -> CAGradientLayer {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = UIColor(red: 188.0/255.0, green: 148.0/255.0, blue: 148.0/255.0, alpha: 1.0).CGColor
        let colorBottom: AnyObject = UIColor(red: 186.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0).CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        progressLabel.text = ""
    }
    
    func reset() {
        progressLayer.fillColor = nil
        let colorTop: AnyObject = UIColor(red: 188.0/255.0, green: 148.0/255.0, blue: 148.0/255.0, alpha: 1.0).CGColor
        let colorBottom: AnyObject = UIColor(red: 186.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0).CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
    }
    
    func animateProgressView() {
        progressLabel.text = "Loading..."
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 0.3
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        progressLayer.addAnimation(animation, forKey: "strokeEnd")
        
        
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        progressLabel.text = "Done"
        let colorTop: AnyObject = UIColor(red: 111.0/255.0, green: 183.0/255.0, blue: 138.0/255.0, alpha: 1.0).CGColor
        let colorBottom: AnyObject = UIColor(red: 81.0/255.0, green: 146.0/255.0, blue: 106.0/255.0, alpha: 1.0).CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
       // progressLayer.fillColor = UIColor(red: 111.0/255.0, green: 183.0/255.0, blue: 138.0/255.0, alpha: 1.0).CGColor
        
    }
    
    
    
    
    
    
    
}
