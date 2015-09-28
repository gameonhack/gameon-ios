//
//  GroupsViewController.swift
//  Game On Hackathon
//
//  Created by Eduardo Irías on 9/27/15.
//  Copyright © 2015 Game On Hackathon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "groupCell"

class GroupsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var groups : [Group] = []
    
    @IBOutlet var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.AllEvents)
        collectionView.addSubview(refreshControl)

    }
    override func viewWillAppear(animated: Bool) {
        getGroups()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        getGroups()
        refreshControl.endRefreshing()
    }
    
    func getGroups() {
        DataManager.getGroups(nil) { (records : [PFObject]?, error : NSError?) -> Void in
            if let groups = records as? [Group] {
                self.groups = groups
                self.collectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showGroup" {
            if let groupViewController = segue.destinationViewController as? GroupViewController, let indexPath = collectionView.indexPathsForSelectedItems()?.first {
                groupViewController.group = groups[indexPath.row]
            }
        }
    }

    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return groups.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GroupCollectionViewCell
        
        // Configure the cell
        let group = groups[indexPath.row]
        
        cell.nameLabel.text = group.name
        group.downloadIconImage { (data : NSData?, error :NSError?) -> Void in
            if let data = data {
                cell.iconImageView.clipsToBounds = true
                cell.iconImageView.image = UIImage(data: data)
            }
        }
        cell.gameNameLabel.text = ""
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var itemsCount : CGFloat = 2.0
        if UIApplication.sharedApplication().statusBarOrientation != UIInterfaceOrientation.Portrait {
            itemsCount = 3.0
        }
        return CGSize(width: self.view.frame.width/itemsCount - 20, height: 220/155 * (self.view.frame.width/itemsCount - 20));
    }
    
    // MARK: - UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
