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
    
    @NSManaged var play: String
    
    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext!) {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
}
