//
//  PostCommentTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 3/13/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {
    
    var delegate : PostTableViewCellDelegate?
    
    var indexPath: IndexPath? {
        return (superview?.superview as? UITableView)?.indexPath(for: self)
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PostCommentTableViewCell.showUserAction) )
        userImageView.addGestureRecognizer(gesture)
        userImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showUserAction() {
        delegate?.shouldShowUserProfile?(atIndexPath: self.indexPath!)
    }
}
