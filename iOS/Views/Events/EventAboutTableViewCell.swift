//
//  EventAboutTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 1/26/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class EventAboutTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: TitleView!
    @IBOutlet weak var aboutTitleLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
