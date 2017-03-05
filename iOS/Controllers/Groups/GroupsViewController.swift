//
//  GroupsViewController.swift
//  Game On
//
//  Created by Julio Marín on 11/2/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var groups = [Group](){
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        DataManager.getGroups { (groups, error) in
            if let groups = groups {
                self.groups = groups
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowGroupDetailSegue" {
            if let vc = segue.destination as? GroupViewController, let indexPath = tableView.indexPathForSelectedRow  {
                vc.group = groups[indexPath.row]
            }
        }
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupTableViewCell
        cell.backgroundColor = UIColor.clear
        
        let group = self.groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        cell.membersLabel.text = group.membersCount.stringValue + " Members"
        cell.iconGroupImageView.image = #imageLiteral(resourceName: "Logo")
        group.getFile(forKey: #keyPath(Group.icon)) { (data) in
            if let data = data {
                cell.iconGroupImageView.image = UIImage(data: data)
                cell.layoutIfNeeded()
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate

}
