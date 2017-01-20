//
//  Post.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return "Post"
    }
    
    @NSManaged var user : User!
    @NSManaged var content : String!
    @NSManaged var image : UIImage?
    
    
}
