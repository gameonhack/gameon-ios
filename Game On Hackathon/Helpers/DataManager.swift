//
//  DataManager.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/26/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let EventClass = "Event"
    static let NotificationClass = "Notification"
    static let GroupClass = "Group"
    
    //MARK: - GET
    
    static func getEvents (options : NSDictionary!, completionBlock: PFQueryArrayResultBlock)  {
        //Search for recomendations
        
        let query = Event.query()!
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByAscending("date")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }

    static func getFeed (options : NSDictionary!, completionBlock: PFQueryArrayResultBlock)  {
        //Search for recomendations
        
        let query = Notification.query()!
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func getGroups (options : NSDictionary!, completionBlock: PFQueryArrayResultBlock)  {
        //Search for recomendations
        
        let query = Group.query()!
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByAscending("name")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }

}
