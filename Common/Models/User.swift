//
//  User.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class User: PFUser, PFSubclassingSkipAutomaticRegistration {
    
    @NSManaged var name : String!
    @NSManaged var bio : String!
    @NSManaged var image : PFFile!
    @NSManaged var groups : PFRelation<Group>?
    
    var hasGroups : Bool {
        get {
            return groups != nil
        }
    }
    
    func getGroups(block : @escaping ([Group]) -> Void ) {
        if let groups = groups {
            let query = groups.query()
            query.order(byAscending: #keyPath(Group.name))
            query.findObjectsInBackground { (groups, error) in
                if let groups = groups {
                    block(groups)
                }
            }
        }
    }
}
