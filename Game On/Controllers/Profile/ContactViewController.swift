//
//  ContactViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 3/4/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageAction(_ sender: Any) {
        let url = URL(string:"fb-messenger://user-thread/1763240193918296")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url , completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string:"https://m.me/gameonhack")! , completionHandler: nil)
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
