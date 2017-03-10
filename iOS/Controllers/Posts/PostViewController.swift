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
}
class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostTableViewCellDelegate {

    var delegate : PostViewDelegate!
    var indexPath : IndexPath!
    
    var post: Post!
    var postImage : UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "PostCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        guard  let postCell = cell as? PostTableViewCell else  {
            return cell
        }
        
        postCell.delegate = self
        
        postCell.timeLabel.text = post.createdAt!.shortTimeAgo()
        postCell.contentTextView.text = post.content
        
        postCell.usernameLabel.text = post.user.name
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
        
        return postCell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
        let contentHeight = post.content.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
        
        return  contentHeight + (post.image != nil ? 505 : 156)
    }
    
    // MARK: - PostTableViewCellDelegate
    
    func didLikePost(atIndexPath indexPath: IndexPath) {
        guard let user =  User.current() else {
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

        
    }
    
}

