//
//  PlayData.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/4/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import Foundation
import CoreData

@objc(PlayData)
class PlayData: NSManagedObject {
    
    @NSManaged var position: String
    @NSManaged var playType: String
    @NSManaged var wasItCorrect: String
    @NSManaged var gameName: String
    
    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext!) {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}