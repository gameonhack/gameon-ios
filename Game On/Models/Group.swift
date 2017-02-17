//
//  Group.swift
//  Game On
//
//  Created by Julio Marín on 29/1/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Group: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Group"
    }
    
    @NSManaged var name:String!
    @NSManaged var bio:String!
    @NSManaged var status:String!
    @NSManaged var membersCount:NSNumber!
    @NSManaged var icon:PFFile!
    
}
