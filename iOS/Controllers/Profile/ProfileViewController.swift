//
//  ProfileViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 3/13/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileHeaderTableViewDelegate {

    var user : User!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if segue.identifier == "ShowGroupSegue" {
            let cell =  (tableView.cellForRow(at: IndexPath(row: 0, section: 2) )) as! ProfileGroupsTableViewCell
            if let vc = segue.destination as? GroupViewController, let indexPath = cell.collectionView.indexPath(for: sender as! UICollectionViewCell) {
                vc.group = cell.groups?[indexPath.row]
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            return "GroupsCell"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = getCellIdentifier(forIndex: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        if let cell = cell as? ProfileHeaderTableViewCell {
            cell.nameLabel.text = user.name
            cell.usernameLabel.text = user.username!
            cell.delegate = self
            
            user.getFile(forKey: #keyPath(User.image)) { (data) in
                if let data = data {
                    cell.pictureImageView.image = UIImage(data: data)
                }
            }
        }
        
        if let cell = cell as? ProfileAboutTableViewCell {
            cell.aboutTextView.text = user.bio
        }
        
        if let cell = cell as? ProfileGroupsTableViewCell {
            if user.hasGroups {
                if cell.groups == nil {
                    user.getGroups { (groups) in
                        if groups.count > 0 {
                            cell.groups = groups
                        } else {
                            cell.groups = nil
                            
                        }
                    }
                }
            }  else {
                cell.groups = nil
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 140.0
        }
        
        if indexPath.section == 1 {
            
            let defaultHeight : CGFloat = 108.0
            
            guard let user = User.current() else {
                return defaultHeight
            }
            
            var contentHeight : CGFloat = 0.0
            
            if let bio = user.bio {
                let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
                contentHeight = bio.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
            }
            
            return  contentHeight + defaultHeight
        }
        
        if indexPath.section == 2 {
            return 200.0
        }
        
        return 60.0
    }
    
    // MARK: - ProfileHeaderTableViewDelegate
    
    func shouldShowUserProfile() {
        user.getImage { (image) in
            self.showPhotoViewController(image: image)
        }
    }
    
}
