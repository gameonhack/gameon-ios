//
//  Group.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/27/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

class Group: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var bio: String?
    @NSManaged var icon: PFFile?
    
    var imageData : NSData! = nil
    
    static func parseClassName() -> String {
        return DataManager.GroupClass
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
    
    func downloadIconImage (completionBlock: PFDataResultBlock ) {
        if let imageData = imageData {
            completionBlock(imageData, nil)
            return
        }
        icon?.getDataInBackgroundWithBlock({ (data : NSData?, error : NSError?) -> Void in
            if let data = data {
                self.imageData = data
            }
            completionBlock(data, error)
        })
    }
}