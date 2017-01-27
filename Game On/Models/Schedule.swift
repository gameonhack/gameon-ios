//
//  Schedule.swift
//  Game On
//
//  Created by Eduardo Irias on 1/26/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Schedule: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return "Schedule"
    }
    
    @NSManaged var name : String!
    @NSManaged var details : String!
    @NSManaged var isWorkshop : NSNumber!
    @NSManaged var date : Date!
    
}
