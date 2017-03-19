//
//  ProfileHeaderTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 2/7/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

@objc protocol ProfileHeaderTableViewDelegate {
    @objc optional func shouldShowUserProfile()
}

class ProfileHeaderTableViewCell: UITableViewCell {

    weak var delegate : ProfileHeaderTableViewDelegate?
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ProfileHeaderTableViewCell.showUserAction) )
        pictureImageView.addGestureRecognizer(gesture)
        pictureImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    func showUserAction() {
        if let shouldShowUserProfile = delegate?.shouldShowUserProfile {
            shouldShowUserProfile()
        }
    }

}
