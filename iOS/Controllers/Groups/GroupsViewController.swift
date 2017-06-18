//
//  GroupsViewController.swift
//  Game On
//
//  Created by Julio Marín on 11/2/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class GroupsViewController: RootViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AddGroupViewControllerDelegate {
    
    var groups = [Group]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var filterdGroups = [Group]() {
        didSet{
            tableView.reloadData()
        }
    }
    var searchMode = false
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func addGroupAction(_ sender: Any) {
        
        if User.current() == nil {
            self.presentLoginViewController()
            return
        }
        
        let alertController = UIAlertController(title: nil, message: "Would you like to join or create a new group?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let joinAction = UIAlertAction(title: "Join", style: UIAlertActionStyle.default) { (action) in
            
        }
        let createAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.default) { (action) in
            self.performSegue(withIdentifier: "ShowAddGroupSegue", sender: action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        
        alertController.addAction(joinAction)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowGroupDetailSegue" {
            if let groupViewController = segue.destination as? GroupViewController, let indexPath = tableView.indexPath(for: sender as! UITableViewCell)  {
                groupViewController.group = !searchMode ? self.groups[indexPath.row] : filterdGroups[indexPath.row]
            }
        }
        
        if let addGroupViewController = (segue.destination as? UINavigationController)?.topViewController as? AddGroupViewController {
            addGroupViewController.delegate = self
        }
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !searchMode ? groups.count : filterdGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupTableViewCell
        cell.backgroundColor = UIColor.clear
        
        let group = !searchMode ? self.groups[indexPath.row] : filterdGroups[indexPath.row]
        
        cell.groupNameLabel.text = group.name
        cell.membersLabel.text = (group.usersCount?.stringValue ?? "0") + " Members"
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideKeyboard()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMode = !(searchBar.text == "")
        if !searchMode {
            searchBar.endEditing(true)
            tableView.reloadData()
            return
        }
        filterdGroups = groups.filter({ (group) -> Bool in
            return group.name.localizedCaseInsensitiveContains(searchText)
        })
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - AddGroupViewControllerDelegate
    
    func didCreated(group: Group) {
        self.groups.append(group)
        self.groups.sort { (group1, group2) -> Bool in
            return group1.name < group2.name
        }
        
        guard let index = self.groups.index(of: group) else {
            return
        }
        
        let indexPath = tableView.cellForRow(at: IndexPath(row: index, section: 0 ))
        self.performSegue(withIdentifier: "ShowGroupDetailSegue", sender: indexPath)
    }
    
}
