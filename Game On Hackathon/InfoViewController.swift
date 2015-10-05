//
//  InfoViewController.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 10/4/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

protocol InfoViewDelegate {
    func infoViewAction()
}

class InfoViewController: UIViewController {

    var buttonTitle: String?
    var message : String?
    var icon : UIImage?
    
    var delegate : InfoViewDelegate?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let buttonTitle = buttonTitle {
            actionButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        }
        
        if let message = message {
            messageLabel.text = message
        }
        
        if let icon = icon {
            iconImageView.image = icon
        }
        
        if let parent = self.parentViewController as? InfoViewDelegate {
            delegate = parent
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func buttonAction (sender : AnyObject) {
        if let delegate = delegate {
            delegate.infoViewAction()
        }
    }

}
