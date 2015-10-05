//
//  ProfileViewController.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 10/4/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, InfoViewDelegate {

    var profileDetails = ["name", "username", "email", "group"]
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.inCircle()
        
        if PFUser.currentUser() != nil {
            dispatch_async(dispatch_queue_create("imageDownload", nil)) { () -> Void in
                let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
                if let data = NSData(contentsOfURL: url!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.profileImageView.image = UIImage(data: data)
                        
                    })
                }
                
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.hidden = false
        profileImageView.hidden = false
        infoContainerView.hidden = true
        logOutButton.enabled = true
        
        if PFUser.currentUser() == nil {
            infoContainerView.hidden = false
            tableView.hidden = true
            profileImageView.hidden = true
            logOutButton.enabled = false
            
            return
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let detail = profileDetails[indexPath.row]
        cell.textLabel?.text = detail
        cell.detailTextLabel?.text = ""
        
        if let value = PFUser.currentUser()?[detail] as? String {
            cell.detailTextLabel?.text = value
        }
        
        if let group = PFUser.currentUser()?[detail] as? Group {
            cell.detailTextLabel?.text = group.name
        }
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */

   // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "infoSegue" {
            if let infoViewController = segue.destinationViewController as? InfoViewController {
                infoViewController.buttonTitle = "Login"
                infoViewController.message = "Please login to view your profile"
            }
        }
    }

    // MARK: - InfoViewDelegate
    
    func infoViewAction() {
        self.performSegueLogin()
    }
    
    //MARK: - Actions
    
    @IBAction func logOuyAction (sender : AnyObject) {
        PFUser.logOut()
        infoContainerView.hidden = false
        
        tableView.hidden = true
        profileImageView.hidden = true
        logOutButton.enabled = false
    }
    
}
