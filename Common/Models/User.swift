//
//  User.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
    /// The user's name
    @NSManaged var name : String!
    /// The user's bio or description
    @NSManaged var bio : String!
    /// The user's image
    @NSManaged var image : PFFile?
    /// The user's groups relation
    @NSManaged var groups : PFRelation<Group>?
    
    /// The user's flag to verify if the user belongs to at least at 1 group.
    var hasGroups : Bool {
        get {
            return groups != nil
        }
    }
    
    /**
     
     Get all group from the user. The request is ordered in ascending way by the user's name.
     
     - Parameter block: A block returning the requested array of Groups or an error
     - Parameter groups: The requested array of groups
     
     */
    func getGroups(block : @escaping ([Group]) -> Void ) {
        DataManager.getGroupsFrom(user: self, block: block)
    }
    
    func getImage(block : @escaping (_ image : UIImage) -> Void) {
        self.getFile(forKey: #keyPath(User.image)) { (data) in
            if let data = data {
                block(UIImage(data: data)!)
            }
        }
    }
}
