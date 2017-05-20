//
//  GroupCreatedViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 5/11/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class GroupCreatedViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.hidesBackButton = true
        
        iconImageView.image = nil
        iconImageView.animationImages = [#imageLiteral(resourceName: "Ckarl 1"), #imageLiteral(resourceName: "Ckarl 2")]
        iconImageView.animationDuration = 0.5
        iconImageView.startAnimating()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.dismiss(animated: true) { 
            
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

}
