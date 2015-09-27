//
//  Event.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/26/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

class Event: PFObject, PFSubclassing {
    
    @NSManaged var caption: String?
    @NSManaged var date: NSDate?
    
    static func parseClassName() -> String {
        return DataManager.EventClass
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}
