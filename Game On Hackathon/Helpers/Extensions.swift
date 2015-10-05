//
//  Extensions.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/28/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

extension UIView {
    func inCircle () {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
extension UINavigationBar {
    func transparent () {
        
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.translucent = true
        self.backgroundColor = UIColor.clearColor()
        self.shadowImage = UIImage()
        
    }
}

extension UIViewController {
    func performSegueLogin() {
        if let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("loginNavigationController") as? UINavigationController {
           self.presentViewController(loginViewController, animated: true, completion: { () -> Void in
            
           })
        }
    }
}