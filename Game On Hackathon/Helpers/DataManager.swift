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
    
    //MARK: - GET
    
    static func getEvents (options : NSDictionary!, completionBlock: PFQueryArrayResultBlock)  {
        //Search for recomendations
        
        let query = Event.query()!
        if let options = options {
            for (key, value)  in options {
                query.whereKey(key as! String , equalTo: value )
            }
        }
        query.orderByAscending("name")
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}
