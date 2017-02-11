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
            }
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
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
        
        let group = groups![indexPath.row]
        
        cell.nameLabel.text = group.name
        
        group.getFile(forKey: #keyPath(Group.icon)) { (data) in
            if let data = data {
                cell.photoImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }

}
