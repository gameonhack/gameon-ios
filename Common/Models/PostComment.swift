//
//  PostComment.swift
//  Game On
//
//  Created by Eduardo Irias on 3/10/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class PostComment: PFObject, PFSubclassingSkipAutomaticRegistration {
    
    static func parseClassName() -> String {
        return "PostComment"
    }
    
    /// The comment's user
    @NSManaged var user : User!
    /// The comment of the post
    @NSManaged var comment : String!
    
}
