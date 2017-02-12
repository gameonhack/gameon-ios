//
//  AddPostViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 2/12/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

protocol AddPostViewDelegate {
    func didAdded(post: Post)
}

class AddPostViewController: UIViewController, UITextViewDelegate {

    let user = User.current()
    var delegate: AddPostViewDelegate?
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var sharePlaceholderLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarBottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addHideKeyboardWithTapGesture()
        self.addKeyboardNotifications()
        
        guard let user = user else {
            cancelAction(self)
            return
        }
        
        userNameLabel.text = user.name
        userUsernameLabel.text = user.username
        user.getFile(forKey: #keyPath(User.image)) { (data: Data?) in
            if let data = data {
                self.userPhotoImageView.image = UIImage(data: data)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if toolbarBottomLayoutConstraint.constant == 0{
                toolbarBottomLayoutConstraint.constant += keyboardSize.height
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if toolbarBottomLayoutConstraint.constant != 0{
            toolbarBottomLayoutConstraint.constant = 0
        }
    }

    
    @IBAction func cancelAction(_ sender: Any) {
        self.hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: Any) {
        if postTextView.text == "" {
            return
        }
        postButton.isEnabled = false
        
        let post = Post()
        post.content = postTextView.text
        post.user = user
        post.saveInBackground { (success, error) in
            if success {
                self.hideKeyboard()
                self.dismiss(animated: true, completion: { 
                    if let delegate = self.delegate {
                        delegate.didAdded(post: post)
                    }
                })
            } else {
                self.postButton.isEnabled = true
            }
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

    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        sharePlaceholderLabel.isHidden = textView.text != ""
    }
}
