//
//  OverallStatsView.swift
//  Game Replay
//
//  Created by Daniel Drake on 9/6/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class OverallStatsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = DataForDisplay()
    var informationForBarGraph = [String]()
    var graphInfo = [String]()
    var detailInfo = [String]()
    var collectionHeight: Float = 0.0
    var countTotal = 0
    var countCorrectTotal = 0

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
        
        count()
        data.setItemsToDisplayForOverall()
        if(data.items_to_display.isEmpty){
            data.numberOfItems = 1
            
        }else{
            data.numberOfItems = data.items_to_display.count
            
        }
        if(data.numberOfItems % 2 == 0){
            collectionHeight = Float(365 + ((350 * data.numberOfItems)))
        }else
        {
            data.numberOfItems++
            collectionHeight = Float(365 + ((350 * data.numberOfItems)))
        }
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.frame.size.height = CGFloat(collectionHeight / 2)
       // playCount.text = "\(countTotal)"
        //correctCount.text = "\(countCorrectTotal)"
        //gamePercentage.text = NSString(format: "%.0f%@", Float(data.totalCorrectForGame) / Float(data.totalCountForGame) * 100, "%") as String
        if(data.items_to_display.isEmpty){
            
           // gamePercentage.text = "0%"
        }else
        {
        
        }
        getDetailInfo()
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "OverallStatsView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func count(){
        
        var locations  = [PlayData]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
        do{
            locations = try context.executeFetchRequest(fetchRequest) as! [PlayData]
        } catch{}
        
        for location in locations {
            
            if (location.play.componentsSeparatedByString("+")[4] == "YES" && location.play.componentsSeparatedByString("+")[6] == gameNameForData){
                countCorrectTotal++
            }
            if(location.play.componentsSeparatedByString("+")[6] == gameNameForData) {
                countTotal++
            }
        }
        
        
        
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.items_to_display.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let title = cell.viewWithTag(1) as! UILabel
        let percentage = cell.viewWithTag(2) as! UILabel
        //let correctCalls = cell.viewWithTag(3) as! UILabel
        //let totalCalls = cell.viewWithTag(4) as! UILabel
        let labelDetail = cell.viewWithTag(5) as! UILabel
        
        var t = ""
        var tCall: Float = 0.0
        var cCall: Float = 0.0
        var p: Float = 0.0
        
        
        if(data.items_to_display[indexPath.row] == "TRAIL"){
            
            t = "TRAIL"
            tCall = Float(data.trailCount)
            cCall = Float(data.trailCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "CENTER"){
            
            t = "CENTER"
            tCall = Float(data.centerCount)
            cCall = Float(data.centerCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "LEAD"){
            
            t = "LEAD"
            tCall = Float(data.leadCount)
            cCall = Float(data.leadCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "PERIMETER"){
            
            t = "PERIMETER"
            tCall = Float(data.perimeterCount)
            cCall = Float(data.perimeterCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "POST"){
            
            t = "POST"
            tCall = Float(data.postCount)
            cCall = Float(data.postCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "TRANSITION"){
            
            t = "TRANSITION"
            tCall = Float(data.transitionCount)
            cCall = Float(data.transitionCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "ON BALL"){
            
            t = "ON BALL"
            tCall = Float(data.onBallCount)
            cCall = Float(data.onBallCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "OFF BALL"){
            
            t = "OFF BALL"
            tCall = Float(data.offBallCount)
            cCall = Float(data.offBallCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "NO CALL"){
            
            t = "NO CALL"
            tCall = Float(data.noCallCount)
            cCall = Float(data.noCallCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "SCREEN"){
            
            t = "SCREEN"
            tCall = Float(data.screenCount)
            cCall = Float(data.screenCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "OUT OF BOUNDS"){
            
            t = "OUT OF BOUNDS"
            tCall = Float(data.outOfBoundsCount)
            cCall = Float(data.outOfBoundsCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "SHOT CLOCK"){
            
            t = "SHOT CLOCK"
            tCall = Float(data.shotClockCount)
            cCall = Float(data.shotClockCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "10 SECONDS"){
            
            t = "10 SECONDS"
            tCall = Float(data.tenSecondsCount)
            cCall = Float(data.tenSecondsCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "DOUBLE DRIBBLE"){
            
            t = "DOUBLE DRIBBLE"
            tCall = Float(data.doubleDribbleCount)
            cCall = Float(data.doubleDribbleCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "BLOCK/CHARGE"){
            
            t = "BLOCK/CHARGE"
            tCall = Float(data.blockChargeCount)
            cCall = Float(data.blockChargeCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "KICK BALL"){
            
            t = "KICK BALL"
            tCall = Float(data.kickBallCount)
            cCall = Float(data.kickBallCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "JUMP BALL"){
            
            t = "JUMP BALL"
            tCall = Float(data.jumpBallCount)
            cCall = Float(data.jumpBallCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "TRAVELING"){
            
            t = "TRAVELING"
            tCall = Float(data.travelingCount)
            cCall = Float(data.travelingCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "FREE THROW"){
            
            t = "FREE THROW"
            tCall = Float(data.freeThrowCount)
            cCall = Float(data.freeThrowCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "THROW IN"){
            
            t = "THROW IN"
            tCall = Float(data.throwInCount)
            cCall = Float(data.throwInCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "BACK COURT"){
            
            t = "BACK COURT"
            tCall = Float(data.backCourtCount)
            cCall = Float(data.backCourtCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "SHOOTING"){
            
            t = "SHOOTING"
            tCall = Float(data.shootingCount)
            cCall = Float(data.shootingCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "ARM BAR"){
            
            t = "ARM BAR"
            tCall = Float(data.armBarCount)
            cCall = Float(data.armBarCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "RA/LDB"){
            
            t = "RA/LDB"
            tCall = Float(data.RACount)
            cCall = Float(data.RACorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "REBOUND"){
            
            t = "REBOUND"
            tCall = Float(data.reboundCount)
            cCall = Float(data.reboundCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "HAND CHECK"){
            
            t = "HAND CHECK"
            tCall = Float(data.handCheckCount)
            cCall = Float(data.handCheckCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "HELD BALL"){
            
            t = "HELD BALL"
            tCall = Float(data.heldBallCount)
            cCall = Float(data.heldBallCorrect)
            p = Float(cCall / tCall)
        }
        
        informationForBarGraph.append("\(p)" + "+" + "\(t)")
        
        title.text = t
        percentage.text = NSString(format: "%.0f%@", p * 100, "%") as String
        //correctCalls.text = "\(Int(cCall))"
        //totalCalls.text = "\(Int(tCall))"
        labelDetail.text = " You had \(Int(cCall)) correct calls out of \(Int(tCall))"
        
        
        
        getInfoForBarGraph()
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            return CGSizeMake(511, 350)
       
    }
    
    
    func getInfoForBarGraph() {
        
        for item in informationForBarGraph {
            
            if(!graphInfo.contains(item)){
                graphInfo.append(item)
            }
            
        }
        graphInfo.sortInPlace(<)
    }
    
    func getDetailInfo() {
        
        var locations  = [PlayData]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
        do{
            locations = try context.executeFetchRequest(fetchRequest) as! [PlayData]
        } catch{}
        
        for location in locations {
            detailInfo.append(location.play)
        }
    
    
    
    
    
    
    }
    
    

}
