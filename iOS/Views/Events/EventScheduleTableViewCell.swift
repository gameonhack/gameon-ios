//
//  EventScheduleTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 1/27/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class EventScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
