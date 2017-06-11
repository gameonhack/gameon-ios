//
//  GroupTitleTableViewCell.swift
//  Game On
//
//  Created by Julio Marín on 6/3/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

protocol GroupTitleTableViewCellDelegate {
    func didPressJoinButton()
}
class GroupTitleTableViewCell: UITableViewCell {

    var delegate : GroupTitleTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: TitleView!
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBOutlet weak var joinCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func joinGroupAction(_ sender: Any) {
        delegate?.didPressJoinButton()
    }
}
