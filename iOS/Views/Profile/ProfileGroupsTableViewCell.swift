//
//  ProfileGroupsTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 2/11/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class ProfileGroupsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var groups : [Group]? {
        didSet {
            if let groups = groups {
                if groups.count >= 0 {
                    titleLabel.text = "Groups"
                }
                noGroupView.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
            } else {
                noGroupView.isHidden = false
                collectionView.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noGroupView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let groups = groups {
            return groups.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! ProfileGroupCollectionViewCell
        
        guard let group = groups?[indexPath.row] else {
            return cell
        }
        
        cell.nameLabel.text = group.name
        
        group.getFile(forKey: #keyPath(Group.icon)) { (data) in
            if let data = data {
                cell.photoImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }

}
