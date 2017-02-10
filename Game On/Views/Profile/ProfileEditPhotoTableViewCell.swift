//
//  ProfileEditPhotoTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 2/10/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

@objc protocol ProfileEditPhotoTableViewCellDelegate {
    func shouldChoosePhoto()
}

class ProfileEditPhotoTableViewCell: UITableViewCell {

    weak var delegate : ProfileEditPhotoTableViewCellDelegate!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(choosePhotoAction(_:)))
        photoImageView.addGestureRecognizer(gesture)
        photoImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func choosePhotoAction(_ sender: Any) {
        delegate.shouldChoosePhoto()
    }
}
