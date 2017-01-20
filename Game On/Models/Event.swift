//
//  Event.swift
//  Game On
//
//  Created by Eduardo Irias on 1/20/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Event: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Event"
    }

    @NSManaged var name : String!
    @NSManaged var caption : String!
    @NSManaged var price : NSNumber!
    @NSManaged var date : Date!
    @NSManaged var icon : PFFile!
    @NSManaged var banner : PFFile!
}
