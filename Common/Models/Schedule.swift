//
//  Schedule.swift
//  Game On
//
//  Created by Eduardo Irias on 1/26/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Schedule: PFObject, PFSubclassingSkipAutomaticRegistration {

    static func parseClassName() -> String {
        return "Schedule"
    }
    
    /// The schedule's name
    @NSManaged var name : String!
    /// The schedule's details
    @NSManaged var details : String!
    /// The schedule's workshop flag
    @NSManaged var isWorkshop : NSNumber!
    /// The schedule's date
    @NSManaged var date : Date!
    
}
