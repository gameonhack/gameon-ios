//
//  LoginViewController.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/23/15.
//  Copyright (c) 2015 Game On Hackathon. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var userEmailLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email", "user_friends"]
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshUserInfo ()
    }

    func refreshUserInfo () {
        let user = PFUser.currentUser()
        if (user != nil) {
            if let name = user?.objectForKey("name") as? String {
                userNameLabel.text = name
            }
            if let email = user?.objectForKey("email") as? String {
                userEmailLabel.text = email
            }
        } else {
            userNameLabel.text = ""
            userEmailLabel.text = ""
        }
    }
    
    func linkInfo() {
        PFFacebookUtils.logInInBackgroundWithAccessToken(FBSDKAccessToken.currentAccessToken()) { (user : PFUser?, error : NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                let req = FBSDKGraphRequest(graphPath: "me", parameters:  ["fields":"email,name"])
                req.startWithCompletionHandler({ (connection : FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                    if let name = result["name"] as? String {
                        user["name"] = name
                        user.saveEventually()
                    }
                    if let email = result["email"] as? String {
                        user["email"] = email
                        user.saveEventually()
                    }
                    self.refreshUserInfo ()
                })
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if !result.isCancelled {
            self.linkInfo()
        }
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOut()
        refreshUserInfo ()
    }
    
    //MARK: - Actions
    
    @IBAction func cancelAction (sender : AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }


}

