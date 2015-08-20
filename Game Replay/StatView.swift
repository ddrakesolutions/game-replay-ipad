//
//  StatView.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/19/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class StatView: UIView {
    
    @IBOutlet weak var trailProgressView: StatsProgressView!
    @IBOutlet weak var centerProgressView: StatsProgressView!
    @IBOutlet weak var leadProgressView: StatsProgressView!
    
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
        let nib = UINib(nibName: "StatView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        setStats()
        return view
    }
    
    func setStats(){
        
        var locations  = [PlayData]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
        do{
            locations = try context.executeFetchRequest(fetchRequest) as! [PlayData]
        } catch{}
        // Then you can use your propertys.
        
        for location in locations {
            
            print("What position where you in? \(location.position)")
            print("What type of play? \(location.playType)")
            print("Did you get it right? \(location.wasItCorrect)")
            print("---------------------------------")
            
        }
        
    trailProgressView.animateProgressViewToProgress(0.65)
    centerProgressView.animateProgressViewToProgress(0.82)
    leadProgressView.animateProgressViewToProgress(0.93)
    trailProgressView.updateProgressViewLabelWithProgress(0.62 * 100)
    centerProgressView.updateProgressViewLabelWithProgress(0.82 * 100)
    leadProgressView.updateProgressViewLabelWithProgress(0.93 * 100)
    }
    
    @IBAction func closeStats(sender: AnyObject) {
        
            UIView.animateWithDuration(0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { [unowned self] in
                    self.frame.origin.y = 900
                }, completion: nil)
        
        
    }
    
    
}