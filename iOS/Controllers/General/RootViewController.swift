//
//  RootViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 1/18/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var topview : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        topview.backgroundColor = UIColor.white
        self.view.addSubview(topview)
        
        topview.translatesAutoresizingMaskIntoConstraints = false
        topview.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        topview.leftAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        topview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        topview.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeTopGap() {
        topview.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITabBarDelegate
    

}
