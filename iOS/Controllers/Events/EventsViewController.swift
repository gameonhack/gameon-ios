//
//  EventsViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 1/20/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class EventsViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var events = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        removeTopGap()
        
        DataManager.getEvents { (events, error) in
            if let events = events {
                self.events = events
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.shared.statusBarStyle = .default
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
        if segue.identifier == "ShowEventSegue" {
            if let vc = segue.destination as? EventViewController, let indexPath = tableView.indexPathForSelectedRow  {
                vc.event = events[indexPath.row]
            }
        }
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1  ? 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = indexPath.section == 0 ? "EventHeaderDecorationCell" : ( indexPath.section == 1 ? "EventHeaderCell" :  "EventCell")
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        if indexPath.section == 0 || indexPath.section == 1  {
            return cell
        }
        
        guard let eventCell = cell as? EventTableViewCell else {
            return cell
        }
        
        let event = events[indexPath.row]
        
        eventCell.nameLabel.text = event.name
        
        event.getFile(forKey: #keyPath(Event.icon)) { (data) in
            if let data = data {
                if let image = UIImage(data: data) {
                    eventCell.iconImageView.image = image
                    eventCell.layoutIfNeeded()
                }
            }
        }
        
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 215.0 : (indexPath.section == 1 ? 90.0 : 100.0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }
    
}
