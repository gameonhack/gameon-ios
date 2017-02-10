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

extension Notification.Name {
    static let GOShowLogin = Notification.Name("show-login")
}

extension Date {
    func shortTimeAgo() -> String {
        return NSDate().shortTimeAgo(since: self)
    }
    
    func truncateTime() -> Date {
        let date = (self as NSDate)
        let year = String(date.year())
        let month = String(date.month())
        let day = String(date.day())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: year + "-" + month + "-" + day)!
    }
    func hourTime() -> String {
        let date = (self as NSDate)
        let hour = date.hour() <= 12 ? date.hour() : date.hour() - 12
        let amPm = date.hour() < 12 ? "AM" : "PM"
        let minutes = date.minute() < 10 ? "0\(date.minute())" : "\(date.minute())"
        return "\(hour):\(minutes) \(amPm)"
    }
}

extension UIImage {
    func resize(toWidth width: CGFloat) -> UIImage {
        
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
    
    func setFile(forKey key : String, withData data : Data, andName name: String, block : ((_ succeeded : Bool, _ error: Error?) -> Void)? ) {
        
        let identifier = self.parseClassName + key + self.objectId!
        PFObject.filesCache![identifier] = data
        
        let file = PFFile(name: name, data: data)
        file?.saveInBackground(block: { (succeeded, error) in
            self.setValue(file, forKey: key)
            self.saveInBackground(block: { (succeeded, error) in
                if let block = block {
                    block(succeeded, error)
                }
            })
        })
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


extension UIViewController {
    
    func addHideKeyboardWithTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}
