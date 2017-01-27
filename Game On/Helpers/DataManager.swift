//
//  DataManager.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class DataManager: NSObject {

    
    static func getPosts(block: @escaping (_ : [Post]?, _ : Error?) -> Void) {
        let query = PFQuery(className: Post.parseClassName())
        query.order(byDescending: #keyPath(Post.createdAt))
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            block(objects as? [Post], error)
        }
    }
    
    static func getEvents(block: @escaping (_ : [Event]?, _ : Error?) -> Void) {
        let query = PFQuery(className: Event.parseClassName())
        query.order(byAscending: #keyPath(Event.date))
        query.includeKey(#keyPath(Event.schedules))
        query.findObjectsInBackground { (objects, error) in
            block(objects as? [Event], error)
        }
    }
    
}
