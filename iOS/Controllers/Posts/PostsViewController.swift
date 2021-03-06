//
//  PostsViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 1/18/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class PostsViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, PostTableViewCellDelegate, PostViewDelegate, AddPostViewDelegate {

    var posts = [Post]() {
        didSet {
            if refreshControl.isRefreshing || loadingActivityIndicatorView.isAnimating {
                loadingActivityIndicatorView.stopAnimating()
                refreshControl.endRefreshing()
                tableView.reloadData()
            }
        }
    }

    var refreshControl: UIRefreshControl = UIRefreshControl()

    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PostsViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.refresh(nil)
    }

    func refresh(_ sender : Any?) {
        DataManager.getPosts { (posts, error) in
            if let posts = posts {
                self.posts = posts
            }
        }
    }
    
    func delete(post : Post) {
        post.deleteInBackground(block: { (success, error) in
            
        })
        self.feedbackSuccess()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func postAction(_ sender: Any) {
        if User.current() == nil {
            self.presentLoginViewController()
        } else {
            self.performSegue(withIdentifier: "ShowAddPostSegue", sender: sender)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAddPostSegue" {
            if let vc = (segue.destination as! UINavigationController).topViewController as? AddPostViewController {
                vc.delegate = self
            }
        }
        
        if segue.identifier == "ShowPostDetailSegue" {
            if let vc = segue.destination as? PostViewController, let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                vc.post = posts[indexPath.row]
                vc.delegate = self
                vc.indexPath = indexPath
            }
        }
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PostCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        guard  let postCell = cell as? PostTableViewCell else  {
            return cell
        }
        
        return configure(postCell: postCell, ForRowAt: indexPath)
    }

    @discardableResult func configure(postCell : PostTableViewCell, ForRowAt indexPath: IndexPath) -> UITableViewCell {
        postCell.delegate = self
        
        let post = posts[indexPath.row]
        
        postCell.timeLabel.text = post.createdAt!.shortTimeAgo()
        postCell.contentTextView.text = post.content
        postCell.contentTextView.isUserInteractionEnabled = false
        
        postCell.usernameLabel.text = post.user.name
        post.user.getFile(forKey: #keyPath(User.image), withBlock: { (data) in
            if let data = data {
                if let image = UIImage(data: data) {
                    postCell.userImageView.image = image
                }
            }
        })
        
        if post.image != nil {
            postCell.showImage()
            
            post.getFile(forKey: #keyPath(Post.image), withBlock: { (data) in
                if let data = data {
                    if let image = UIImage(data: data) {
                        postCell.postImageView.image = image
                    }
                }
            })
        } else {
            postCell.hideImage()
        }
        
        let postLikes = post.likesCount?.intValue ?? 0
        postCell.likeButton.setTitle(" \(postLikes)", for: UIControlState.normal)
        postCell.likeButton.setImage(UIImage(named: "Heart"), for: UIControlState.normal)
        
        post.getLikes { (users, error) in
            
            if let _ = error {
                return
            }
            
            if let user = User.current() {
                if post.isLikedBy(user: user) {
                    postCell.likeButton.setImage(UIImage(named: "Heart Filled"), for: UIControlState.normal)
                }
            }
            
        }
        
        return postCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
        let contentHeight = post.content.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
        
        return  contentHeight + (post.image != nil ? 332 : 156)
    }
    
    // MARK: - PostTableViewCellDelegate
    
    func didLikePost(atIndexPath indexPath: IndexPath) {
        guard let user =  User.current() else {
            self.presentLoginViewController()
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        if !post.isLikedBy(user: user) {
            post.addLikeFrom(user: user) { (success, error) in
                self.configure(postCell: cell, ForRowAt: indexPath)
            }
            cell.likeButton.setImage(UIImage(named: "Heart Filled"), for: UIControlState.normal)
        } else {
            post.removeLikeFrom(user: user, block: { (success, error) in
                self.configure(postCell: cell, ForRowAt: indexPath)
            })
            cell.likeButton.setImage(UIImage(named: "Heart"), for: UIControlState.normal)
        }
        
        configure(postCell: cell, ForRowAt: indexPath)
        cell.likeButton.addSpringAnimation()
    }
    
    func didCommentPost(atIndexPath indexPath: IndexPath) {
        
    }
    
    func didToggleMorePost(atIndexPath indexPath: IndexPath) {
        let user =  User.current()
        
        let post = posts[indexPath.row]
        
        var actions = [UIAlertAction]()
        
        if user?.objectId == post.user.objectId {
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.didDeleted(post: post, indexPath: indexPath)
            })
            actions.append(deleteAction)
            
        } else {
            
            let reportAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.destructive, handler: { (action) in
                
            })
            actions.append(reportAction)
            
        }
        
        let shareAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.default, handler: { (action) in
            
            if post.image != nil {
                post.getImage(block: { (image) in
                    self.presentShareActivyController(content: [post.content, image])
                })
            } else {
                self.presentShareActivyController(content: [post.content])
            }

        })
        actions.append(shareAction)
        
        self.presentActionSheetAlertController(actions: actions)
    }
    
    func shouldShowUserProfile(atIndexPath indexPath: IndexPath) {
        let user = posts[indexPath.row].user!
        showUserProfileViewController(user: user)
    }
    
    // MARK: - PostViewDelegate
    
    func didliked(post: Post, indexPath: IndexPath) {
        posts[indexPath.row] = post
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        configure(postCell: cell, ForRowAt: indexPath)
    }
    
    func didDeleted(post : Post, indexPath: IndexPath) {
        self.delete(post: post)
        self.posts.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
    }
    
    // MARK: - AddPostViewDelegate
    
    func didAdded(post: Post) {
        posts.insert(post, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.top)
    }
}
