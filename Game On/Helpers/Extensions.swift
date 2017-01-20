//
//  Extensions.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

extension PFObject {
    
    fileprivate static var filesCache : [String: Any]?
    
    func getFile(forKey key : String, withBlock block: @escaping (_ : Data?) -> Void) {
        let classname = self.parseClassName
        
        if PFObject.filesCache == nil {
            PFObject.filesCache =  [String: Any]()
        }
        if let data = PFObject.filesCache![classname + key] as? Data {
            block(data)
        } else {
            
            if let file = self.value(forKey: key) as? PFFile {
                file.getDataInBackground(block: { (data, error) in
                    
                    PFObject.filesCache![classname + key] = data
                    block(data)
                })
            }
        }
    }
    
}
