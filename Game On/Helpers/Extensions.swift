//
//  Extensions.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse
import DateTools

extension Date {
    func shortTimeAgo() -> String {
        return NSDate().shortTimeAgo(since: self)
    }
}

extension PFObject {
    
    fileprivate static var filesCache : [String: Any]?
    
    func getFile(forKey key : String, withBlock block: @escaping (_ : Data?) -> Void) {
        let classname = self.parseClassName
        
        if PFObject.filesCache == nil {
            PFObject.filesCache =  [String: Any]()
        }
        
        let identifier = classname + key + self.objectId!
        if let data = PFObject.filesCache![identifier] as? Data {
            block(data)
        } else {
            
            if let file = self.value(forKey: key) as? PFFile {
                file.getDataInBackground(block: { (data, error) in
                    
                    PFObject.filesCache![identifier] = data
                    block(data)
                })
            }
        }
    }
    
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

}
