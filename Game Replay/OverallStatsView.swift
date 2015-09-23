//
//  OverallStatsView.swift
//  Game Replay
//
//  Created by Daniel Drake on 9/6/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class OverallStatsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteDataView: UIVisualEffectView!
    @IBOutlet weak var noDataHeader: UILabel!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var markedPlayTitle: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var commentTitle: UILabel!
    
    var data = DataForDisplay()
    var informationForBarGraph = [String]()
    var graphInfo = [String]()
    var detailInfo = [String]()
    var collectionHeight: Float = 0.0
    var countTotal = 0
    var countCorrectTotal = 0
    var scrollHeight: Float = 0.0
    var tableHeight: Float = 0.0

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
            scrollHeight = Float(740 + ((350 * data.numberOfItems)))
            collectionHeight = Float(365 + ((350 * data.numberOfItems)))
        }else
        {
            data.numberOfItems++
            scrollHeight = Float(736 + ((350 * data.numberOfItems)))
            collectionHeight = Float(365 + ((350 * data.numberOfItems)))
        }
        
        view = loadViewFromNib()
        
        if(data.items_to_display.isEmpty){
            
            noDataHeader.hidden = false
            noDataMessage.hidden = false
            
        }else
        {
            noDataHeader.hidden = true
            noDataMessage.hidden = true
        }
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        commentTable.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
        collectionView.frame.size.height = CGFloat(collectionHeight / 2)
        deleteDataView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
        deleteDataView.hidden = false
        scrollView.delegate = self
        commentTable.delegate = self
        if(data.items_to_display.isEmpty){
            
           // gamePercentage.text = "0%"
        }else
        {
        
        }
        deleteDataView.layer.masksToBounds = true
        deleteDataView.layer.cornerRadius = 10
        getDetailInfo()
        addSubview(view)
    }
    
    func xibReload() {
        
        view.removeFromSuperview()
        count()
        
        data.setItemsToDisplayForOverall()
        if(data.items_to_display.isEmpty){
            data.numberOfItems = 1
            
        }else{
            data.numberOfItems = data.items_to_display.count
            
        }
        if(data.numberOfItems % 2 == 0){
            scrollHeight = Float(740 + ((350 * data.numberOfItems)))
            collectionHeight = Float(30 + ((350 * data.numberOfItems)))
        }else
        {
            data.numberOfItems++
            scrollHeight = Float(736 + ((350 * data.numberOfItems)))
            collectionHeight = Float(30 + ((350 * data.numberOfItems)))
        }
        
        view = loadViewFromNib()
        
        if(data.items_to_display.isEmpty && data.commentsForOverall.isEmpty){
            
            noDataHeader.hidden = false
            noDataMessage.hidden = false
            dataImage.hidden = false
            data.reset()
            commentTitle.hidden = true
            markedPlayTitle.hidden = true
            collectionView.backgroundColor = UIColor.whiteColor()
            scrollView.backgroundColor = UIColor.whiteColor()
            lineView.hidden = true
            
        }else
        {
            if(data.items_to_display.isEmpty){
                markedPlayTitle.hidden = true
            }else{
                markedPlayTitle.hidden = false
            }
    
            lineView.hidden = false
            noDataHeader.hidden = true
            noDataMessage.hidden = true
            dataImage.hidden = true
            commentTitle.hidden = false
        }
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        commentTable.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
        collectionView.frame.size.height = CGFloat(collectionHeight / 2) - 20
        deleteDataView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
        deleteDataView.hidden = false
        scrollView.delegate = self
        deleteDataView.layer.masksToBounds = true
        deleteDataView.layer.cornerRadius = 10
        commentTable.delegate = self
        tableHeight = Float(365 + ((150 * data.numberOfItems)))
        commentTable.frame.size.height = CGFloat(50 * data.commentsForOverall.count)
        collectionView.frame.origin.y = CGFloat(50 * data.commentsForOverall.count + 130)
        markedPlayTitle.frame.origin.y = CGFloat(50 * data.commentsForOverall.count + 100)
        scrollView.contentSize = CGSize(width: 1024, height: commentTable.frame.size.height + collectionView.frame.size.height + 145)
        lineView.frame.origin.y = CGFloat(50 * data.commentsForOverall.count + 130)
        commentTitle.frame.origin.y = 60
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
        let correctCalls = cell.viewWithTag(3) as! UILabel
        let totalCalls = cell.viewWithTag(4) as! UILabel
        let labelComment = cell.viewWithTag(5) as! UITextView
        let labelCorrectCalls = cell.viewWithTag(10) as! UILabel
        
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
            labelComment.text = "\n"
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
            labelComment.text = "\n"
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
        
        if(data.items_to_display[indexPath.row] == "TEAM CONTROL"){
            
            t = "TEAM CONTROL"
            tCall = Float(data.teamControlCount)
            cCall = Float(data.teamControlCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "HACK/HIT ON ARM"){
            
            t = "HACK/HIT ON ARM"
            tCall = Float(data.hackCount)
            cCall = Float(data.hackCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "HOLD"){
            
            t = "HOLD"
            tCall = Float(data.holdCount)
            cCall = Float(data.holdCorrect)
            p = Float(cCall / tCall)
        }
        
        
        informationForBarGraph.append("\(p)" + "+" + "\(t)")
        
        labelComment.hidden = true
        correctCalls.hidden = true
        totalCalls.hidden = true
        title.text = t
        
        percentage.text = NSString(format: "%.0f%@", p * 100, "%") as String
        correctCalls.text = "\(Int(cCall))"
        totalCalls.text = "\(Int(tCall))"
        if(correctCalls.text == "0" || correctCalls.text == "1"){
            labelCorrectCalls.text = "\(Int(cCall)) correct call out of \(Int(tCall))"
        }else{
            labelCorrectCalls.text = "\(Int(cCall)) correct calls out of \(Int(tCall))"
        }
        
        
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
    
    
    
    @IBAction func deleteData(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
        do{
            let plays = try context.executeFetchRequest(fetchRequest) as! [PlayData]
            
            if plays.count > 0 {
                
                for result: AnyObject in plays{
                    context.deleteObject(result as! NSManagedObject)
                }
                try context.save() } } catch {}
        
        UIView.animateWithDuration(0.1,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.deleteDataView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            }, completion: nil)
        
        awakeFromNib()
    }
    
    
    
    @IBAction func cancel(sender: UIButton) {
        
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.deleteDataView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            }, completion: nil)
        
    }
    
    @IBAction func clearData(sender: UIButton) {
        
        UIView.animateWithDuration(0.1,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.deleteDataView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.commentsForOverall.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCellWithIdentifier("cell2") as UITableViewCell?)!
        
        let c = cell.viewWithTag(1) as! UILabel
        
        switch data.commentsForOverall[indexPath.row] {
            
        case "TRAIL":
            
            c.text = "     TRAIL"
            c.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
            c.textColor = UIColor.lightGrayColor()
            
        case "CENTER":
            
            c.text = "      CENTER"
            c.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
            c.textColor = UIColor.lightGrayColor()
            
        case "LEAD":
            
            c.text = "      LEAD"
            c.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
            c.textColor = UIColor.lightGrayColor()
            
        default:
            c.text = "      ⚐ " + data.commentsForOverall[indexPath.row]
            
        }
        
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50.0
    }

    
    
    override func awakeFromNib() {
        data.reset()
        xibReload()
        collectionView.reloadData()
        countTotal = 0
        countCorrectTotal = 0
        commentTable.reloadData()
    }
    
    

}