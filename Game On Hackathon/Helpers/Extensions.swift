//
//  Extensions.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/28/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func transparent () {
        
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.translucent = true
        self.backgroundColor = UIColor.clearColor()
        self.shadowImage = UIImage()
        
    }
}
