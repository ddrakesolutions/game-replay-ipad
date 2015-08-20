//
//  StatsViewController.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/4/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics
import QuartzCore

class StatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let gname = cell.viewWithTag(5) as! UILabel
        gname.text = "Memphis vs Missouri State"
        return cell
    }

    
   

}
