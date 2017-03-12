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

    // MARK: - Posts
    
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
     
     Get all Posts filtered by the options paramenter. If the options paramenter is nil the function will query all the posts. The request includes the posts's user.
     
     - Parameter options: A dictionary to filter the posts request
     - Parameter block: A block returning the requested array of posts or an error
     - Parameter posts: The requested array of Posts
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getLikesFrom(post : Post, block: @escaping (_  posts : [User]?, _ error : Error?) -> Void) {
        guard let likes = post.likes else  {
            block(nil, nil )
            return
        }
        let query = likes.query()
        query.order(byDescending: #keyPath(Post.createdAt))
        query.findObjectsInBackground { (objects, error) in
            block(objects, error)
        }
    }
    
    /**
     
     Get all Posts filtered by the options paramenter. If the options paramenter is nil the function will query all the posts. The request includes the posts's user.
     
     - Parameter options: A dictionary to filter the posts request
     - Parameter block: A block returning the requested array of posts or an error
     - Parameter posts: The requested array of Posts
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getCommentsFrom(post : Post, block: @escaping (_  posts : [PostComment]?, _ error : Error?) -> Void) {
        guard let comments = post.comments else  {
            block(nil, nil )
            return
        }
        let query = comments.query()
        query.order(byAscending: #keyPath(PostComment.createdAt))
        query.findObjectsInBackground { (objects, error) in
            block(objects, error)
        }
    }
    
    // MARK: - Events
    
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
     
     Get all Schedules from an Event.
     
     - Parameter event: The event from which the schedules will be requested
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    static func getSchedulesFrom(event: Event, block : @escaping ([Schedule]) -> Void ) {
        let query = event.schedules.query()
        query.order(byAscending: #keyPath(Schedule.date))
        query.findObjectsInBackground { (schedules, error) in
            block(schedules!)
        }
    }
    
    // MARK: - Groups
    
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
    
    /**
     
     Get all Groups from a specific user. The request is ordered in ascending way by the name.
     
     - Parameter user: The user from which the groups will be requested.
     - Parameter block: A block returning the requested array of Groups or an error
     - Parameter events: The requested array of groups
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getGroupsFrom(user : User, block : @escaping ([Group]) -> Void ) {
        if let groups = user.groups {
            let query = groups.query()
            query.order(byAscending: #keyPath(Group.name))
            query.findObjectsInBackground { (groups, error) in
                if let groups = groups {
                    block(groups)
                }
            }
        }
    }
    
    /**
     
     Get all user from a Group. If the options paramenter is nil the function will query all the groups. The request is ordered in ascending way by the name.
     
     - Parameter options: A dictionary to filter the groups request
     - Parameter block: A block returning the requested array of Groups or an error
     - Parameter events: The requested array of groups
     - Parameter error: Error if it fails to get the posts
     
     */
    static func getUsersFrom(group : Group, block: @escaping (_  users: [User]?, _ error : Error?) -> Void) {
        
        let usersQuery = User.query()!
        usersQuery.whereKey(#keyPath(User.groups), equalTo: group)
        usersQuery.order(byAscending: #keyPath(User.name))
        usersQuery.findObjectsInBackground { (objects, error) in
            block(objects as? [User], error)
        }
        
    }
    
}
