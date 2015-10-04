//
//  FeedViewController.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/26/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notifications : [Notification] = []
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.hidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.AllEvents)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            return
        }
        getFeed()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.tabBarController?.selectedIndex = 0
            self.performSegueLogin()
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        getFeed()
        refreshControl.endRefreshing()
    }
    
    func getFeed() {
        if let user = PFUser.currentUser() {
            let dc = NSDictionary(object: user, forKey: "user")
            DataManager.getFeed(dc) { (records : [PFObject]?, error : NSError?) -> Void in
                if let error = error {
                    self.messageLabel.text = error.description
                    return
                }
                if let count = records?.count {
                    if count == 0 {
                        self.messageLabel.text = "No hay actividad reciente"
                        return
                    }
                }
                if let notifications = records as? [Notification] {
                    self.notifications = notifications
                    self.tableView.reloadData()
                    self.tableView.hidden = false
                    self.messageLabel.hidden = true
                }
            }
        }
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
        return notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let event = notifications[indexPath.row]
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM HH:mm aa"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let dateString = dateFormatter.stringFromDate(event.createdAt!)
        
        cell.textLabel?.text = event.caption
        cell.detailTextLabel?.text = dateString
        
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

