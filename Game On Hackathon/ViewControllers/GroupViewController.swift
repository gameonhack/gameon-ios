//
//  GroupViewController.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/27/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    var group : Group!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = group.name
        bioTextView.text = group.bio
        group.downloadIconImage({ (data: NSData?, error: NSError?) -> Void in
            if let data = data {
                self.iconImageView.image = UIImage(data: data)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        //scrollViewHeight.constant = self.view.frame.width + 60 + 100 + 145
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
