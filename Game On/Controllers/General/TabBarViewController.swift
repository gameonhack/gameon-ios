//
//  TabBarViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 2/5/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.showLogin(_:)), name: NSNotification.Name.GOShowLogin , object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLogin(_ sender : Any) {
       self.performSegue(withIdentifier: "ShowLoginSegue", sender: sender)
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
