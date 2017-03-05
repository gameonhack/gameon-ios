//
//  Post.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassingSkipAutomaticRegistration {

    static func parseClassName() -> String {
        return "Post"
    }
    
    /// The post's user. This is the user that created the Post.
    @NSManaged var user : User!
    /// The post's content
    @NSManaged var content : String!
    /// The pot's image file. **Default** is nil. Use getFile function to get the image.
    @NSManaged var image : PFFile?
    
}
