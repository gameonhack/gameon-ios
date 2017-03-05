//
//  GroupViewController.swift
//  Game On
//
//  Created by Julio Marín on 25/2/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var group : Group!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
        print("Salsa")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITableViewDataSource (Delegated)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Cristal")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("mantequilla")
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cocacola")
        let identifier = getCellIdentifier(index: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        if let cell = cell as? ImageTableViewCell {
            cell.imageImageView.image = #imageLiteral(resourceName: "Logo")
            group.getFile(forKey: #keyPath(Group.icon), withBlock: { (data) in
                if let data = data {
                    cell.imageImageView.image = UIImage(data: data)
                    cell.layoutIfNeeded()
                }
            })
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - UITableViewDataSource (Custom)
    
    func getCellIdentifier(index : Int) -> String {
        return "GroupHeaderDecorationCell"
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //if let indexPath = self.tableview.indexPathsForVisibleRows?.first {
          //  UIApplication.shared.statusBarStyle = .lightContent
        //}
        if let imageCell = self.tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }

}
