//
//  GroupUsersTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 3/25/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

@objc protocol GroupUserCollectionViewCellDelegate {
    func shouldOpen(user: User)
}

class GroupUsersTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var delegate : GroupUserCollectionViewCellDelegate?
    
    var users = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! GroupUserCollectionViewCell
        let user = users[indexPath.row]
        
        user.getImage { (image) in
            cell.userImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        delegate?.shouldOpen(user: user)
    }
}
