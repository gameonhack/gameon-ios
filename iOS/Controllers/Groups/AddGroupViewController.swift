//
//  AddGroupViewController.swift
//  Game On
//
//  Created by Julio Marín on 25/2/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

protocol AddGroupViewControllerDelegate {
    func didCreated(group: Group)
}

class AddGroupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate : AddGroupViewControllerDelegate?
    
    let group = Group()
    
    @IBOutlet weak var groupIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        changeNavigationAndStatusBarToClear()
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.hideKeyboard()
        changeNavigationAndStatusBarToClear()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func choosePhotoAction(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.sourceType = .photoLibrary
        imageController.delegate = self
        imageController.navigationBar.backgroundColor = UIColor.white
        imageController.allowsEditing = true
        self.present(imageController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let addGroupDetailsViewController = segue.destination as? AddGroupDetailsViewController {
            group.name = nameLabel.text ?? "No name 👹"
//            group.create(iconImage: groupIconImageView.image!)
            /*
            group.setFile(forKey: #keyPath(Group.icon), withData: UIImagePNGRepresentation(groupIconImageView.image!)!, andName: "icon.png", block: { (succcess, error) in
                
            })
             */
            addGroupDetailsViewController.delegate = delegate
            addGroupDetailsViewController.group = group
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            groupIconImageView.image = image.resize(toWidth: 400.00)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    

}
