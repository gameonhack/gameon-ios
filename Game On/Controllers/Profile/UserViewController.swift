//
//  UserViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 2/6/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class UserViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {

    var didShowLogin = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.current() != nil {
            tableView.reloadData()
        }
        if User.current() == nil && didShowLogin {
            self.tabBarController?.selectedIndex = 0
            didShowLogin = false
            return
        }
        if User.current() == nil && !didShowLogin {
            didShowLogin = true
            NotificationCenter.default.post(name: NSNotification.Name.GOShowLogin, object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSections(in tableView: UITableView) -> Int {
        return User.current() == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func getCellIdentifier(forIndex index : Int) -> String {
        switch index {
        case 0:
            return "ProfileHeaderCell"
        case 1:
            return "AboutCell"
        case 2:
            return "LogOutCell"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = getCellIdentifier(forIndex: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        guard let user = User.current() else {
            return cell
        }
        
        if let cell = cell as? ProfileHeaderTableViewCell {
            cell.nameLabel.text = user.name
            cell.usernameLabel.text = user.username!
            
            user.getFile(forKey: #keyPath(User.image)) { (data) in
                if let data = data {
                    cell.pictureImageView.image = UIImage(data: data)
                }
            }
        }
        
        if let cell = cell as? ProfileAboutTableViewCell {
            cell.aboutTextView.text = user.bio
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            guard let user = User.current() else {
                return
            }
            
            let alertController = UIAlertController(title: "Log Out", message: "\(user.name!) are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let logOutAction = UIAlertAction(title: "Log Out", style: UIAlertActionStyle.destructive, handler: { (action) in
                User.logOut()
                self.tableView.reloadData()
                self.tabBarController!.selectedIndex = 0
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertController.addAction(logOutAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 230.0
        }
        
        if indexPath.section == 1 {
            
            let defaultHeight : CGFloat = 108.0
            
            guard let user = User.current() else {
                return defaultHeight
            }
            
            let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
            let contentHeight = user.bio.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
            
            return  contentHeight + defaultHeight
        }
        
        return 60.0
    }
    
}
