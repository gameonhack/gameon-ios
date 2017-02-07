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
    
    @NSManaged var name : String!
    @NSManaged var bio : String!
    @NSManaged var image : PFFile!
    
}
