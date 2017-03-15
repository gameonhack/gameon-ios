//
//  Group.swift
//  Game On
//
//  Created by Julio Marín on 29/1/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Group: PFObject, PFSubclassingSkipAutomaticRegistration {
    
    static func parseClassName() -> String {
        return "Group"
    }
    
    /// The group's name
    @NSManaged var name:String!
    /// The group's bio or description
    @NSManaged var bio:String!
    /// The group's current status
    @NSManaged var status:String!
    /// The group's users count.
    @NSManaged var usersCount:NSNumber?
    /// The group's icon file. Use getFile function to get the image.
    @NSManaged var icon:PFFile!
    /// The group's cover file. Use getFile function to get the image.
    @NSManaged var cover:PFFile!
    
    /**
     
     Get all users from the group. The request is ordered in ascending way by the user's name.
     
     - Parameter block: A block returning the requested array of Users or an error
     - Parameter users: The requested array of users
     - Parameter error: Error if it fails to get the posts
     
     */
    func getUsers(block : @escaping ([User]?, Error?) -> Void ) {
        DataManager.getUsersFrom(group: self, block: block)
    }
}
