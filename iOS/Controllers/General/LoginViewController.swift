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
                    
                    self.feedbackSuccess()
                    
                    if user.isNew {
                        // User signed up and logged in through Facebook!
                        
                        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,email"])!
                        request.start(completionHandler: { (connection, result, error) in
                            if let result = result as? [String : Any] {
                                
                                let facebookID = result["id"] as! String
                                
                                if let name = result["name"] as? String {
                                    user.setValue(name, forKey: #keyPath(User.name))
                                }
                                if let email = result["email"] as? String {
                                    user.email = email
                                }
                                user.saveEventually()
                                let pictureURL = URL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")!
                                guard let data = try? Data(contentsOf: pictureURL) else {
                                    self.performSegue(withIdentifier: "ShowEditProfileSegue", sender: nil)
                                    return
                                }
                                guard let image = UIImage(data: data) else {
                                    self.performSegue(withIdentifier: "ShowEditProfileSegue", sender: nil)
                                    return
                                }
                                let imageData = UIImageJPEGRepresentation(image, 7.0)
                                user.setFile(forKey: #keyPath(User.image), withData: imageData!, andName: "image.jpeg") { (succeeded, error) in
                                    user.saveEventually()
                                    self.performSegue(withIdentifier: "ShowEditProfileSegue", sender: nil)
                                    return
                                }
                            }
                        })
                    
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowEditProfileSegue" {
            if let vc = segue.destination as? EditProfileViewController {
                vc.isFromSignUp = true
            }
        }
    }


}
