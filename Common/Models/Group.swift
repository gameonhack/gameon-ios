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
    
    /// The group's name
    @NSManaged var name: String!
    /// The group's about or description
    @NSManaged var about: String!
    /// The group's current status
    @NSManaged var status: String!
    /// The group's joinCode.
    @NSManaged private(set) public var joinCode: String?
    /// The group's users count.
    @NSManaged var usersCount: NSNumber?
    /// The group's icon file. Use getFile function to get the image.
    @NSManaged var icon: PFFile!
    /// The group's cover file. Use getFile function to get the image.
    @NSManaged var cover: PFFile!
    
    /**
     
     Get all users from the group. The request is ordered in ascending way by the user's name.
     
     - Parameter block: A block returning the requested array of Users or an error
     - Parameter users: The requested array of users
     - Parameter error: Error if it fails to get the posts
     
     */
    func getUsers(block : @escaping ([User]?, Error?) -> Void ) {
        DataManager.getUsersFrom(group: self, block: block)
    }
    
    /**
     
     Gets group's icon in a block
     
     - Parameter block: A block returning the requested icon
     
     */
    func getIcon(block : @escaping (_ image : UIImage) -> Void) {
        self.getFile(forKey: #keyPath(Group.icon)) { (data) in
            if let data = data {
                block(UIImage(data: data)!)
            }
        }
    }
    
    func create(iconImage : UIImage) {
        icon = PFFile(name: "icon.png", data: UIImagePNGRepresentation(iconImage)!)
    }
    
    /**
     
     Gets group's icon in a block
     
     - Parameter block: A block returning the requested icon
     
     */
    func joinGroup(user: User, joinCode : String) {
        PFCloud.callFunction(inBackground: "joinGroup", withParameters: ["groupId" : self.objectId!, "joinCode" : joinCode]) { (response, error) in
            print(response as? String ?? "")
        }
    }
}
