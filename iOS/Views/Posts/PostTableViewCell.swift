//
//  PostTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

@objc protocol PostTableViewCellDelegate {
    @objc optional func didLikePost(atIndexPath indexPath: IndexPath)
    @objc optional func didCommentPost(atIndexPath indexPath: IndexPath)
    @objc optional func didToggleMorePost(atIndexPath indexPath: IndexPath)
    @objc optional func shouldShowUserProfile(atIndexPath indexPath: IndexPath)
}

class PostTableViewCell: UITableViewCell {

    weak var delegate : PostTableViewCellDelegate?
    
    var indexPath: IndexPath? {
        return (superview?.superview as? UITableView)?.indexPath(for: self)
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.showUserAction) )
        userImageView.addGestureRecognizer(gesture)
        
        userImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func hideImage() {
        imageHeightConstraint.constant = 0
        imageBottomConstraint.constant = 0
    }
    
    func showImage(withHeight height : CGFloat =  160) {
        imageHeightConstraint.constant = height
        imageBottomConstraint.constant = 16
    }
    
    // MARK: - Actions
    
    func showUserAction() {
        if let shouldShowUserProfile = delegate?.shouldShowUserProfile {
            shouldShowUserProfile(self.indexPath!)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if let didLikePost = delegate?.didLikePost {
            didLikePost(self.indexPath!)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        if let didCommentPost = delegate?.didCommentPost {
            didCommentPost(self.indexPath!)
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        if let didToggleMorePost = delegate?.didToggleMorePost {
            didToggleMorePost(self.indexPath!)
        }
    }
    
}
