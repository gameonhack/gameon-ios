//
//  GroupViewController.swift
//  Game On
//
//  Created by Julio Marín on 25/2/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GroupUserCollectionViewCellDelegate, GroupTitleTableViewCellDelegate {

    var group : Group!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
        group.getUsers { (users, error) in
            self.tableview.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITableViewDataSource (Delegated)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func getCellIdentifier(index : Int) -> String {
        switch index {
        case 0:
            return "GroupHeaderDecorationCell"
        case 1:
            return "GroupHeaderCell"
        case 2:
            return "AboutCell"
        case 3:
            return "UsersCell"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = getCellIdentifier(index: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        if let cell = cell as? ImageTableViewCell {
            cell.imageImageView.image = #imageLiteral(resourceName: "Logo")
            group.getFile(forKey: #keyPath(Group.cover), withBlock: { (data) in
                if let data = data {
                    cell.imageImageView.image = UIImage(data: data)
                    cell.layoutIfNeeded()
                }
            })
        }
        
        if let cell = cell as? GroupTitleTableViewCell {
            cell.delegate = self
            cell.titleLabel.text = group.name
            group.getUsers { (users, error) in
                guard let user = User.current() else {
                    return
                }
                if users?.contains(where: { (userL) -> Bool in
                    userL.objectId == user.objectId
                }) == true {
                    
                    cell.joinCodeLabel.text = "Join Code: " + (self.group.joinCode ?? "")
                    
                    cell.joinGroupButton.isHidden = true
                    cell.joinCodeLabel.isHidden = false
                    
                } else {
                    cell.joinGroupButton.isHidden = false
                    cell.joinCodeLabel.isHidden = true
                }
            }
        }
        
        if let cell = cell as? GroupAboutTableViewCell {
            cell.aboutTextView.text = group.about
        }
        
        if let cell = cell as? GroupUsersTableViewCell {
            cell.delegate = self
            group.getUsers { (users, error) in
                cell.users = users!
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 255
        case 1:
            return 140.0
        case 2:
            let aboutLabelHeight : CGFloat = 86.0
            let frameSize = CGSize(width: self.view.frame.width - 40.0, height: 1000.0)
            let aboutTextViewSize = group.about.boundingRect(with: frameSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 22)], context: nil)
            return aboutLabelHeight + aboutTextViewSize.height
        case 3:
            return 150
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - GroupUserCollectionViewCellDelegate
    
    func shouldOpen(user: User) {
        self.showUserProfileViewController(user: user)
    }
    
    // MARK: - GroupTitleTableViewCellDelegate
    
    func didPressJoinButton() {
        
        let alertController = UIAlertController(title: "Join Group", message: "You are about to join \(group.name!)", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Group's join code"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        let joinAction = UIAlertAction(title: "Join", style: UIAlertActionStyle.default) { (alertAction) in
            self.group.joinGroup(user: User.current()!, joinCode: alertController.textFields?.first?.text ?? "")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(joinAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        //self.showSimpleAlert(title: "Will join", message: "The code should be \(group.joinCode)")
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //if let indexPath = self.tableview.indexPathsForVisibleRows?.first {
          //  UIApplication.shared.statusBarStyle = .lightContent
        //}
        if let imageCell = self.tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }

}
