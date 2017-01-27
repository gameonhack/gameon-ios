//
//  EventDayHeaderTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 1/26/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class EventDayHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
