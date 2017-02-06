//
//  LoginViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 2/5/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if User.current() != nil {
            facebookButton.setTitle("Log out", for: UIControlState.normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginAction(_ sender: Any) {
        facebookButton.isEnabled = false
        
        if User.current() != nil {
            User.logOut()
            facebookButton.setTitle("Continue with Facebook", for: UIControlState.normal)
            facebookButton.isEnabled = true
        } else {
            PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email", "user_friends"]) { (user, error) in
                if let user = user {
                    if user.isNew {
                        // User signed up and logged in through Facebook!
                        self.performSegue(withIdentifier: "ShowEditSegue", sender: nil)
                    } else {
                        // User logged in through Facebook!
                        self.cancelAction(self.facebookButton)
                    }
                    self.facebookButton.isEnabled = true
                    self.facebookButton.setTitle("Log out", for: UIControlState.normal)
                } else {
                    // Uh oh. The user cancelled the Facebook login.
                    self.facebookButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
