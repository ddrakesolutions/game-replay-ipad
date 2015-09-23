//
//  StatView.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/19/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class StatView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchViewSegment: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playCount: UILabel!
    @IBOutlet weak var correctCount: UILabel!
    @IBOutlet weak var gamePercentage: UILabel!
    @IBOutlet weak var noDataHeader: UILabel!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var overallStatView: OverallStatsView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var markedPlayTitle: UILabel!
    @IBOutlet weak var commentTitle: UILabel!
  
    var data = DataForDisplay()
    var informationForBarGraph = [String]()
    var graphInfo = [String]()
    var detailInfo = [String]()
    var collectionHeight: Float = 0.0
    var scrollHeight: Float = 0.0
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
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "StatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.frame.size.height = CGFloat(collectionHeight / 2)
        scrollView.contentSize = CGSize(width: 1024, height: CGFloat(scrollHeight / 2))
        playCount.text = "\(countTotal)"
        correctCount.text = "\(countCorrectTotal)"
        gamePercentage.text = NSString(format: "%.0f%@", Float(data.totalCorrectForGame) / Float(data.totalCountForGame) * 100, "%") as String
        if(data.items_to_display.isEmpty){
            
            noDataHeader.hidden = false
            noDataMessage.hidden = false
            gamePercentage.text = "0%"
            
        }else
        {
            noDataHeader.hidden = true
            noDataMessage.hidden = true
        }
        overallStatView.hidden = true
        gameNameLabel.text = gameNameForData
        addSubview(view)
        
    }
    
    func xibReload() {
        
        data.setItemsToDisplayForGame()
        view.removeFromSuperview()
        count()
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
        
        
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "StatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        commentTable.registerNib(UINib(nibName: "CommentGameTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
        collectionView.frame.size.height = CGFloat(collectionHeight / 2)
        playCount.text = "\(countTotal)"
        correctCount.text = "\(countCorrectTotal)"
        gamePercentage.text = NSString(format: "%.0f%@", Float(data.totalCorrectForGame) / Float(data.totalCountForGame) * 100, "%") as String
        if(data.items_to_display.isEmpty && data.commentsForGame.isEmpty){
            
            noDataHeader.hidden = false
            noDataMessage.hidden = false
            dataImage.hidden = false
            data.reset()
            commentTitle.hidden = true
            gamePercentage.text = "0%"
            markedPlayTitle.hidden = true
            
        }else
        {
            if(data.items_to_display.isEmpty){
                gamePercentage.text = "0%"
                markedPlayTitle.hidden = true
            }else{
                markedPlayTitle.hidden = false
            }
            
            noDataHeader.hidden = true
            noDataMessage.hidden = true
            dataImage.hidden = true
            commentTitle.hidden = false
        }
        overallStatView.hidden = true
        gameNameLabel.text = gameNameForData
        commentTable.delegate = self
        commentTable.frame.size.height = CGFloat(50 * data.commentsForGame.count)
        commentTable.frame.origin.y = CGFloat(415)
        collectionView.frame.origin.y = CGFloat(commentTable.frame.origin.y + commentTable.frame.size.height + 40)
        commentTitle.frame.origin.y = CGFloat(385)
        markedPlayTitle.frame.origin.y = CGFloat(commentTable.frame.origin.y + commentTable.frame.size.height + 10)
        scrollView.contentSize = CGSize(width: 1024, height: commentTable.frame.size.height + collectionView.frame.size.height + 278)
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "StatView", bundle: bundle)
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
                if (location.play.componentsSeparatedByString("+")[4] == "YES" && location.play.componentsSeparatedByString("+")[6] == gameFile){
                    countCorrectTotal++
                }
                if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
                    countTotal++
                }
        }
        

        
        
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
        let labelDetail = cell.viewWithTag(5) as! UILabel
        let correctCalls = cell.viewWithTag(3) as! UILabel
        let totalCalls = cell.viewWithTag(4) as! UILabel
        
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
        
        if(data.items_to_display[indexPath.row] == "TEAM CONTROL"){
            
            t = "TEAM CONTROL"
            tCall = Float(data.teamControlCount)
            cCall = Float(data.teamControlCorrect)
            p = Float(cCall / tCall)
        }
        
        if(data.items_to_display[indexPath.row] == "HACK/HIT ON ARM"){
            
            t = "HACK"
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
        
        correctCalls.hidden = true
        totalCalls.hidden = true
    
        title.text = t
        percentage.text = NSString(format: "%.0f%@", p * 100, "%") as String
        correctCalls.text = "\(Int(cCall))"
        totalCalls.text = "\(Int(tCall))"
        if(correctCalls.text == "0" || correctCalls.text == "1"){
            labelDetail.text = " You had \(Int(cCall)) correct call out of \(Int(tCall))"
        }else{
            labelDetail.text = " You had \(Int(cCall)) correct calls out of \(Int(tCall))"
        }

            
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(data.items_to_display.isEmpty){
        return CGSizeMake(1024, 350)
        }else{
        return CGSizeMake(511.5, 350)
        }
    }
    
    
    
    @IBAction func informationSelect(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            overallStatView.hidden = true
            awakeFromNib()
        case 1:
            overallStatView.awakeFromNib()
            overallStatView.hidden = false
        default:
            break
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.commentsForGame.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCellWithIdentifier("cell2") as UITableViewCell?)!
        
        let c = cell.viewWithTag(1) as! UILabel
        
        switch data.commentsForGame[indexPath.row] {
            
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
            c.text = "      ⚐ " + data.commentsForGame[indexPath.row]
            
        }
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.clearColor()
        }else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    
    
    
    
   

    override func awakeFromNib() {
        switchViewSegment.selectedSegmentIndex = 0
        data.reset()
        xibReload()
        collectionView.reloadData()
        countTotal = 0
        countCorrectTotal = 0
        commentTable.reloadData()
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
}