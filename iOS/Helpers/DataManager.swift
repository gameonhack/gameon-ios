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

    /**
     
     Get all Posts filtered by the options paramenter. If the options paramenter is nil the function will query all the posts. The request includes the posts's user.
     
     - Parameter options: A dictionary to filter the posts request
     - Parameter block: A block returning the requested array of posts or an error
     - Parameter posts: The requested array of Posts
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getPosts(options : [String : Any]? = nil, block: @escaping (_  posts : [Post]?, _ error : Error?) -> Void) {
        let query = PFQuery(className: Post.parseClassName())
        query.whereEquals(options: options)
        query.order(byDescending: #keyPath(Post.createdAt))
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            block(objects as? [Post], error)
        }
    }
    
    /**
     
     Get all Events filtered by the options paramenter. If the options paramenter is nil the function will query all the events.
     
     - Parameter options: A dictionary to filter the events request
     - Parameter block: A block returning the requested array of posts or an error
     - Parameter events: The requested array of Events
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getEvents(options : [String : Any]? = nil, block: @escaping (_  events: [Event]?, _ error : Error?) -> Void) {
        let query = PFQuery(className: Event.parseClassName())
        query.whereEquals(options: options)
        query.order(byAscending: #keyPath(Event.date))
        query.includeKey(#keyPath(Event.schedules))
        query.findObjectsInBackground { (objects, error) in
            block(objects as? [Event], error)
        }
    }
    
    /**
     
     Get all Groups filtered by the options paramenter. If the options paramenter is nil the function will query all the groups. The request is ordered in ascending way by the name.
     
     - Parameter options: A dictionary to filter the groups request
     - Parameter block: A block returning the requested array of Groups or an error
     - Parameter events: The requested array of groups
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getGroups(options : [String : Any]? = nil, block: @escaping (_  groups: [Group]?, _ error : Error?) -> Void) {
        let query = PFQuery(className: Group.parseClassName())
        query.whereEquals(options: options)
        query.order(byAscending: #keyPath(Group.name))
        query.findObjectsInBackground { (objects, error) in
            block(objects as? [Group], error)
        }
    }
    
}
