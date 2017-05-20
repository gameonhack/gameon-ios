//
//  AddGroupDetailsViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 5/5/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class AddGroupDetailsViewController: UIViewController, UITextViewDelegate {

    var group : Group!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = group.name
        descriptionTextView.text = group.about
        self.iconImageView.image = UIImage(data: try! group.icon.getData())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveAction(_ sender: Any) {
        self.navigationItem.backBarButtonItem?.isEnabled = false
        (sender as? UITabBarItem)?.isEnabled = false
        descriptionTextView.resignFirstResponder()
        
        group.saveInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "ShowGroupCreatedSegue", sender: sender)
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
        group.about = descriptionTextView.text
    }
}
