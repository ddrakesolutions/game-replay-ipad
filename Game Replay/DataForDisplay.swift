//
//  DataForDisplay.swift
//  Game Replay
//
//  Created by Daniel Drake on 9/2/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class DataForDisplay: NSObject {
    
    var items = [String]()
    var items_to_display = [String]()
    var i = 0
    var scrollHeight: Float = 0.0
    var collectionHeight: Float = 0.0
    var numberOfItems = 0
    
    var totalCountForGame = 0
    var totalCorrectForGame = 0
    
    var trailCount = 0
    var trailCorrect = 0
    
    var centerCount = 0
    var centerCorrect = 0
    
    var leadCount = 0
    var leadCorrect = 0
    
    var perimeterCount = 0
    var perimeterCorrect = 0
    
    var postCount = 0
    var postCorrect = 0
    
    var transitionCount = 0
    var transitionCorrect = 0
    
    var onBallCount = 0
    var onBallCorrect = 0
    
    var offBallCount = 0
    var offBallCorrect = 0
    
    var noCallCount = 0
    var noCallCorrect = 0
    
    var screenCount = 0
    var screenCorrect = 0
    
    var outOfBoundsCount = 0
    var outOfBoundsCorrect = 0
    
    var shotClockCount = 0
    var shotClockCorrect = 0
    
    var tenSecondsCount = 0
    var tenSecondsCorrect = 0
    
    var doubleDribbleCount = 0
    var doubleDribbleCorrect = 0
    
    var blockChargeCount = 0
    var blockChargeCorrect = 0
    
    var kickBallCount = 0
    var kickBallCorrect = 0
    
    var jumpBallCount = 0
    var jumpBallCorrect = 0
    
    var travelingCount = 0
    var travelingCorrect = 0
    
    var freeThrowCount = 0
    var freeThrowCorrect = 0
    
    var throwInCount = 0
    var throwInCorrect = 0
    
    var backCourtCount = 0
    var backCourtCorrect = 0
    
    var shootingCount = 0
    var shootingCorrect = 0
    
    var armBarCount = 0
    var armBarCorrect = 0
    
    var RACount = 0
    var RACorrect = 0
    
    var reboundCount = 0
    var reboundCorrect = 0
    
    var handCheckCount = 0
    var handCheckCorrect = 0
    
    var heldBallCount = 0
    var heldBallCorrect = 0
    

    
    override init() {
    }
    
    
    
    func setItemsToDisplayForGame(){
        
        var locations  = [PlayData]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
        do{
            locations = try context.executeFetchRequest(fetchRequest) as! [PlayData]
        } catch{}
        
    
        
        for location in locations {
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            items.append(location.play.componentsSeparatedByString("+")[0] as String)
            }
        }
        
        for location in locations {
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            items.append(location.play.componentsSeparatedByString("+")[1] as String)
            }
        }
            
        
        for location in locations {
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            items.append(location.play.componentsSeparatedByString("+")[2] as String)
            }
        }
        
        for location in locations {
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            items.append(location.play.componentsSeparatedByString("+")[3] as String)
            }
        }
        
        for location in locations {
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            items.append(location.play.componentsSeparatedByString("+")[4] as String)
            }
        }
        
        for location in locations {
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            items.append(location.play.componentsSeparatedByString("+")[5] as String)
            }
        }
        
        
        
        
        for item in items {
            
        
            
            if(!items_to_display.contains(item)){
                
                
                if(item.containsString("TRAIL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("CENTER")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("LEAD")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("PERIMETER")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("POST")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("TRANSITION")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("ON BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("OFF BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("SCREEN")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("OUT OF BOUNDS")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("SHOT CLOCK")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("10 SECONDS")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("DOUBLE DRIBBLE")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("BLOCK/CHARGE")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("KICK BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("JUMP BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("TRAVELING")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("FREE THROW")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("THROW IN")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("BACK COURT")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("SHOOTING")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("ARM BAR")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("RA/LDB")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("REBOUND")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("HAND CHECK")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("HELD BALL")){
                    items_to_display.append(item)
                }
                
                
                
                
            }
        
        
        
    }
        
        //--------------------------------------Count Each Position--------------------------------------------//
        for location in locations {
            
            if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
            
            //=================POSITION========================//
            if(location.play.componentsSeparatedByString("+")[0] == "TRAIL") {
                trailCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    trailCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[0] == "CENTER") {
                centerCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    centerCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[0] == "LEAD") {
                leadCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    leadCorrect++
                    totalCorrectForGame++
                }
            }
            
            
            //=================PLAY OCCURRANCE========================//
            
            
            if(location.play.componentsSeparatedByString("+")[1] == "PERIMETER") {
                perimeterCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    perimeterCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[1] == "POST") {
                postCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    postCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[1] == "TRANSITION") {
                transitionCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    transitionCorrect++
                    totalCorrectForGame++
                }
            }
            
            
            //=================CALL TYPE========================//
            
            
            if(location.play.componentsSeparatedByString("+")[2] == "ON BALL") {
                onBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    onBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[2] == "OFF BALL") {
                offBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    offBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[2] == "NO CALL") {
                noCallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    noCallCorrect++
                    totalCorrectForGame++
                }
            }
            
            
            //=================PLAY TYPE========================//
            
            
            if(location.play.componentsSeparatedByString("+")[3] == "SCREEN") {
                screenCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    screenCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "OUT OF BOUNDS") {
                outOfBoundsCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    outOfBoundsCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "SHOT CLOCK") {
                shotClockCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    shotClockCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "10 SECONDS") {
                tenSecondsCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    tenSecondsCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "DOUBLE DRIBBLE") {
                doubleDribbleCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    doubleDribbleCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "BLOCK/CHARGE") {
                blockChargeCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    blockChargeCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "KICK BALL") {
                kickBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    kickBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "JUMP BALL") {
                jumpBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    jumpBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "TRAVELING") {
                travelingCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    travelingCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "FREE THROW") {
                freeThrowCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    freeThrowCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "THROW IN") {
                throwInCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    throwInCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "BACK COURT") {
                backCourtCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    backCourtCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "SHOOTING") {
                shootingCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    shootingCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "ARM BAR") {
                armBarCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    armBarCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "RA/LDB") {
                RACount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    RACorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "REBOUND") {
                reboundCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    reboundCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "HAND CHECK") {
                handCheckCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    handCheckCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "HELD BALL") {
                heldBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    heldBallCorrect++
                    totalCorrectForGame++
                }
            }
        }
            
            
            
        }
        
        
    }
    
    func setItemsToDisplayForOverall(){
        
        var locations  = [PlayData]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
        do{
            locations = try context.executeFetchRequest(fetchRequest) as! [PlayData]
        } catch{}
        
        
        
        for location in locations {
            items.append(location.play.componentsSeparatedByString("+")[0] as String)
        }
        
        for location in locations {
            items.append(location.play.componentsSeparatedByString("+")[1] as String)        }
        
        for location in locations {
            items.append(location.play.componentsSeparatedByString("+")[2] as String)
        }
        
        for location in locations {
            items.append(location.play.componentsSeparatedByString("+")[3] as String)
        }
        
        for location in locations {
            items.append(location.play.componentsSeparatedByString("+")[4] as String)
        }
        
        
        for item in items {
            
            
            if(!items_to_display.contains(item)){
                
                
                if(item.containsString("TRAIL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("CENTER")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("LEAD")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("PERIMETER")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("POST")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("TRANSITION")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("ON BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("OFF BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("SCREEN")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("OUT OF BOUNDS")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("SHOT CLOCK")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("10 SECONDS")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("DOUBLE DRIBBLE")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("BLOCK/CHARGE")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("KICK BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("JUMP BALL")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("TRAVELING")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("FREE THROW")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("THROW IN")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("BACK COURT")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("SHOOTING")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("ARM BAR")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("RA/LDB")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("REBOUND")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("HAND CHECK")){
                    items_to_display.append(item)
                }
                
                if(item.containsString("HELD BALL")){
                    items_to_display.append(item)
                }
                
                
                
                
            }
            
            
        }
        
        //--------------------------------------Count Each Position--------------------------------------------//
        for location in locations {
            //=================POSITION========================//
            if(location.play.componentsSeparatedByString("+")[0] == "TRAIL") {
                trailCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    trailCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[0] == "CENTER") {
                centerCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    centerCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[0] == "LEAD") {
                leadCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    leadCorrect++
                    totalCorrectForGame++
                }
            }
            
            
            //=================PLAY OCCURRANCE========================//
            
            
            if(location.play.componentsSeparatedByString("+")[1] == "PERIMETER") {
                perimeterCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    perimeterCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[1] == "POST") {
                postCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    postCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[1] == "TRANSITION") {
                transitionCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    transitionCorrect++
                    totalCorrectForGame++
                }
            }
            
            
            //=================CALL TYPE========================//
            
            
            if(location.play.componentsSeparatedByString("+")[2] == "ON BALL") {
                onBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    onBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[2] == "OFF BALL") {
                offBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    offBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[2] == "NO CALL") {
                noCallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    noCallCorrect++
                    totalCorrectForGame++
                }
            }
            
            
            //=================PLAY TYPE========================//
            
            
            if(location.play.componentsSeparatedByString("+")[3] == "SCREEN") {
                screenCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    screenCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "OUT OF BOUNDS") {
                outOfBoundsCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    outOfBoundsCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "SHOT CLOCK") {
                shotClockCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    shotClockCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "10 SECONDS") {
                tenSecondsCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    tenSecondsCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "DOUBLE DRIBBLE") {
                doubleDribbleCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    doubleDribbleCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "BLOCK/CHARGE") {
                blockChargeCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    blockChargeCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "KICK BALL") {
                kickBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    kickBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "JUMP BALL") {
                jumpBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    jumpBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "TRAVELING") {
                travelingCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    travelingCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "FREE THROW") {
                freeThrowCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    freeThrowCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "THROW IN") {
                throwInCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    throwInCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "BACK COURT") {
                backCourtCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    backCourtCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "SHOOTING") {
                shootingCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    shootingCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "ARM BAR") {
                armBarCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    armBarCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "RA/LDB") {
                RACount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    RACorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "REBOUND") {
                reboundCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    reboundCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "HAND CHECK") {
                handCheckCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    handCheckCorrect++
                    totalCorrectForGame++
                }
            }
            
            if(location.play.componentsSeparatedByString("+")[3] == "HELD BALL") {
                heldBallCount++
                totalCountForGame++
                if (location.play.componentsSeparatedByString("+")[4] == "YES"){
                    heldBallCorrect++
                    totalCorrectForGame++
                }
            }
            
            
        }
        
        
    }
    
    
    func reset() {
        
         items.removeAll()
         items_to_display.removeAll()
         i = 0
         scrollHeight = 0.0
         collectionHeight = 0.0
         numberOfItems = 0
        
         totalCountForGame = 0
         totalCorrectForGame = 0
        
         trailCount = 0
         trailCorrect = 0
        
         centerCount = 0
         centerCorrect = 0
        
         leadCount = 0
         leadCorrect = 0
        
         perimeterCount = 0
         perimeterCorrect = 0
        
         postCount = 0
         postCorrect = 0
        
         transitionCount = 0
         transitionCorrect = 0
        
         onBallCount = 0
         onBallCorrect = 0
        
         offBallCount = 0
         offBallCorrect = 0
        
         noCallCount = 0
         noCallCorrect = 0
        
         screenCount = 0
         screenCorrect = 0
        
         outOfBoundsCount = 0
         outOfBoundsCorrect = 0
        
         shotClockCount = 0
         shotClockCorrect = 0
        
         tenSecondsCount = 0
         tenSecondsCorrect = 0
        
         doubleDribbleCount = 0
         doubleDribbleCorrect = 0
        
         blockChargeCount = 0
         blockChargeCorrect = 0
        
         kickBallCount = 0
         kickBallCorrect = 0
        
         jumpBallCount = 0
         jumpBallCorrect = 0
        
         travelingCount = 0
         travelingCorrect = 0
        
         freeThrowCount = 0
         freeThrowCorrect = 0
        
         throwInCount = 0
         throwInCorrect = 0
        
         backCourtCount = 0
         backCourtCorrect = 0
        
         shootingCount = 0
         shootingCorrect = 0
        
         armBarCount = 0
         armBarCorrect = 0
        
         RACount = 0
         RACorrect = 0
        
         reboundCount = 0
         reboundCorrect = 0
        
         handCheckCount = 0
         handCheckCorrect = 0
        
         heldBallCount = 0
         heldBallCorrect = 0
    }
    
    
}
