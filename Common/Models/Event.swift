//
//  Event.swift
//  Game On
//
//  Created by Eduardo Irias on 1/20/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Event: PFObject {
    
    static func parseClassName() -> String {
        return "Event"
    }

    /// The event's name
    @NSManaged var name : String!
    /// The event's caption or short description
    @NSManaged var caption : String!
    /// The event's price
    @NSManaged var price : NSNumber!
    /// The event's date
    @NSManaged var date : Date!
    /// The event's icon file. Use getFile function to get the image.
    @NSManaged var icon : PFFile!
    /// The event's banner file. Use getFile function to get the image.
    @NSManaged var banner : PFFile!
    /// The event's schedules relation. Use **getSchedules** function to get the schedules.
    @NSManaged var schedules : PFRelation<Schedule>!
    
    /**
     
     Get all Schedules from an Event.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func getSchedules(block : @escaping ([Schedule]) -> Void ) {
        DataManager.getSchedulesFrom(event: self, block: block)
    }
}
