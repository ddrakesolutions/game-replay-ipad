//
//  MarkView.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/19/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit

class MarkView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MyView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
}


}