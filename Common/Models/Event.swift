//
//  Event.swift
//  Game On
//
//  Created by Eduardo Irias on 1/20/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Event: PFObject, PFSubclassingSkipAutomaticRegistration {
    
    static func parseClassName() -> String {
        return "Event"
    }

    @NSManaged var name : String!
    @NSManaged var caption : String!
    @NSManaged var price : NSNumber!
    @NSManaged var date : Date!
    @NSManaged var icon : PFFile!
    @NSManaged var banner : PFFile!
    @NSManaged var schedules : PFRelation<Schedule>!
    
    func getSchedules(block : @escaping ([Schedule]) -> Void ) {
        let query = self.schedules.query()
        query.order(byAscending: #keyPath(Schedule.date))
        query.findObjectsInBackground { (schedules, error) in
            block(schedules!)
        }
    }
}
