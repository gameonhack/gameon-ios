//
//  PostsViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 1/18/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class PostsViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {

    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DataManager.getPosts { (posts, error) in
            if let posts = posts {
                self.loadingActivityIndicatorView.stopAnimating()
                self.posts = posts
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func postAction(_ sender: Any) {
        if User.current() == nil {
            NotificationCenter.default.post(name: NSNotification.Name.GOShowLogin, object: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = indexPath.section == 0 ? "PostHeaderCell" :  "PostCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        guard  let postCell = cell as? PostTableViewCell else  {
            return cell
        }
        
        let post = posts[indexPath.row]
        
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
        
        return postCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            let post = posts[indexPath.row]
            let constraintRect = CGSize(width: self.view.frame.width - 32, height: self.view.frame.height)
            let contentHeight = post.content.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17) ], context: nil).height
            
            return  contentHeight + (post.image != nil ? 332 : 156)
        }
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
