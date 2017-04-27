//
//  PostViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 2/12/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

protocol PostViewDelegate {
    func didliked(post : Post, indexPath: IndexPath)
    func didDeleted(post : Post, indexPath: IndexPath)
}
class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PostTableViewCellDelegate {

    var delegate : PostViewDelegate!
    var indexPath : IndexPath!
    
    var post: Post!
    var postImage : UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset.bottom = 46
        
        self.addHideKeyboardWithTapGesture()
        self.addKeyboardNotifications()
        
        post.getComments(block: { (postComments, error) in
            self.tableView.reloadData()
        })

    }

    override func viewWillAppear(_ animated: Bool) {
        //UINavigationBar.appearance().barTintColor = UIColor.white
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = UIColor.white

        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowPictureSegue" {
            if let vc = segue.destination as? PhotoViewController {
                vc.photo = postImage!
            }
        }
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : post.commentsCount?.intValue ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0 ? "PostCell" : "PostComment"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        if let postCell = cell as? PostTableViewCell {
            
            postCell.delegate = self
            
            postCell.timeLabel.text = post.createdAt!.shortTimeAgo() + " Ago"
            postCell.contentTextView.text = post.content
            
            postCell.usernameLabel.text = post.user.name
            postCell.userUsernameLabel.text = post.user.username
            
            post.user.getFile(forKey: #keyPath(User.image), withBlock: { (data) in
                if let data = data {
                    if let image = UIImage(data: data) {
                        postCell.userImageView.image = image
                    }
                }
            })
            
            if post.image != nil {
                postCell.showImage(withHeight: self.view.frame.width - 40.0 )
                
                post.getFile(forKey: #keyPath(Post.image), withBlock: { (data) in
                    if let data = data {
                        if let image = UIImage(data: data) {
                            self.postImage = image
                            postCell.postImageView.image = image
                        }
                    }
                })
            } else {
                postCell.hideImage()
            }
            
            if let user = User.current() {
                if post.isLikedBy(user: user) {
                    postCell.likeButton.setImage(UIImage(named: "Heart Filled"), for: UIControlState.normal)
                }
            }
        }
        
        if let postCommentCell = cell as? PostCommentTableViewCell {
            postCommentCell.delegate = self
            post.getComments(block: { (postComments, error) in
                if let postComments = postComments {
                    let postComment = postComments[indexPath.row]
                    postCommentCell.dateLabel.text = (postComment.createdAt?.shortTimeAgo() ?? "0m") + " Ago"
                    postCommentCell.commentLabel.text = postComment.comment
                    postCommentCell.userNameLabel.text = postComment.user.name
                    postComment.user.getFile(forKey: #keyPath(User.image), withBlock: { (data) in
                        postCommentCell.userImageView.image = UIImage(data: data!)
                        cell.layoutIfNeeded()
                    })
                }
            })
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
            let contentHeight = post.content.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
            
            return  contentHeight + (post.image != nil ? 505 : 156)
        } else if indexPath.section == 1 {
            if let cachedPostComment = post.cachedPostComment {
                let postComment = cachedPostComment[indexPath.row]
                
                let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
                let contentHeight = postComment.comment.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
                
                return  contentHeight + 60
            }
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var ownsComment = false
        
        if let cachedPostComment = post.cachedPostComment {
            let postComment = cachedPostComment[indexPath.row]

            if User.current()?.objectId == postComment.user.objectId {
                ownsComment = true
            }
        }
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: ownsComment ? "Delete" : "Report", handler: { (action, indexPath) in
            
            if ownsComment {
                self.post.removeCommentFrom(user: User.current()!, atIndex: indexPath.row, block: { (success, error) in
                    
                })
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
            }
        })
        
        return [deleteAction]
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let user = User.current() else {
            self.presentLoginViewController()
            return true
        }
        
        if textField.text == "" {
            return true
        }
        
        post.add(comment: textField.text!, fromUser: user) { (success, error) in
            
        }
        
        textField.text = ""
        tableView.insertRows(at: [IndexPath(row: (self.post.commentsCount?.intValue ?? 1) - 1 , section: 1)], with: UITableViewRowAnimation.bottom)
        
        tableView.scrollToRow(at: IndexPath(row: (self.post.commentsCount?.intValue ?? 1) - 1 , section: 1), at: UITableViewScrollPosition.bottom, animated: true)
 
        self.feedbackSuccess()
        
        return true
    }
    
    // MARK: - PostTableViewCellDelegate
    
    func shouldShowUserProfile(atIndexPath indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.showUserProfileViewController(user: post.user)
        } else {
            guard let user = post.cachedPostComment?[indexPath.row].user else {
                return
            }
            self.showUserProfileViewController(user: user)
        }
    }
    
    func didLikePost(atIndexPath indexPath: IndexPath) {
        guard let user =  User.current() else {
            self.presentLoginViewController()
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        
        if !post.isLikedBy(user: user) {
            post.addLikeFrom(user: user) { (success, error) in
                self.delegate.didliked(post: self.post, indexPath: self.indexPath)
            }
            cell.likeButton.setImage(UIImage(named: "Heart Filled"), for: UIControlState.normal)
        } else {
            post.removeLikeFrom(user: user, block: { (success, error) in
                self.delegate.didliked(post: self.post, indexPath: self.indexPath)
            })
            cell.likeButton.setImage(UIImage(named: "Heart"), for: UIControlState.normal)
        }
        
        cell.likeButton.addSpringAnimation()
        
    }
    
    func didToggleMorePost(atIndexPath indexPath: IndexPath) {
        let user =  User.current()
        
        var actions = [UIAlertAction]()
        
        if user?.objectId == post.user.objectId {
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.delegate.didDeleted(post: self.post, indexPath: self.indexPath)
                let _ = self.navigationController?.popViewController(animated: true)
            })
            actions.append(deleteAction)
            
        } else {
            
            let reportAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.destructive, handler: { (action) in
                let _ = self.navigationController?.popViewController(animated: true)
            })
            actions.append(reportAction)
            
        }
        
        let shareAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.default, handler: { (action) in
            
            if self.post.image != nil {
                self.post.getImage(block: { (image) in
                    self.presentShareActivyController(content: [self.post.content, image])
                })
            } else {
                self.presentShareActivyController(content: [self.post.content])
            }
            
        })
        actions.append(shareAction)
        
        self.presentActionSheetAlertController(actions: actions)
    }
    
}

