//
//  EventViewController.swift
//  Game On
//
//  Created by Eduardo Irias on 1/20/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var event : Event!
    var schedules = [Date : [Schedule]]() {
        didSet {
            for _ in schedules {
                headers.append(nil)
            }
            tableView.reloadData()
        }
    }
    
    var headers = [EventDayHeaderTableViewCell?]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        event.getSchedules { (schedules) in
            for schedule in schedules {
                if self.schedules[schedule.date.truncateTime()] == nil {
                    self.schedules[schedule.date.truncateTime()] = []
                }
                self.schedules[schedule.date.truncateTime()]?.append(schedule)
            }
        }
        
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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + max(schedules.count, 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1 ? 1 : schedules.count > 0 ? schedules[schedules.keys.sorted()[section - 2]]!.count : 1
    }
    
    func getCellIdentifier(index : Int) -> String {
        switch index {
        case 0:
            return "EventHeaderDecorationCell"
        case 1:
            return "EventHeaderCell"
        default:
            return schedules.count > 0 ? "EventScheduleCell" : "EventNoSchedulesCell"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = getCellIdentifier(index: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.selectionStyle = .none
        
        if let cell = cell as? ImageTableViewCell {
            event.getFile(forKey: #keyPath(Event.banner), withBlock: { (data) in
                if let data = data {
                    if let image = UIImage(data: data) {
                        cell.imageImageView.image = image
                        cell.layoutIfNeeded()
                    }
                }
            })
        }
        

        if let cell = cell as? EventAboutTableViewCell {
            cell.titleLabel.text = event.name
            cell.aboutTextView.text = event.caption
        }

        if let cell = cell as? EventScheduleTableViewCell {
            let schedule = schedules[schedules.keys.sorted()[indexPath.section - 2]]![indexPath.row]
            cell.nameLabel.text = schedule.name
            cell.timeLabel.text = schedule.date.hourTime()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 215.0
        case 1:
            let aboutLabelHeight : CGFloat = 178.0
            let frameSize = CGSize(width: self.view.frame.width - 40.0, height: 1000.0)
            let aboutTextViewSize = event.caption.boundingRect(with: frameSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 22)], context: nil)
            return aboutLabelHeight + aboutTextViewSize.height
        default:
            return schedules.count > 0 ? 64.0 : 220.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "EventAboutHeaderCell")
            return headerCell
        }
        
        if schedules.count == 0 {
            return nil
        }
        
        let header = tableView.dequeueReusableCell(withIdentifier: "EventDayHeaderCell") as! EventDayHeaderTableViewCell
        header.dayLabel.text = "Day \(section - 1)"
        
        if headers.count > section - 2 {
            headers[section - 2] = header
        }
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        case 1:
            return 20.0
        default:
            return schedules.count > 0 ? 64.0 : 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for headerCell in headers {
            if let headerCell = headerCell {
                headerCell.dayLabel.textColor = UIColor.lightGray
                headerCell.dayLabel.textAlignment = .left
            }
        }
        
        
        if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
            
            if indexPath.section >= 1 {
                UIApplication.shared.statusBarStyle = .default
            } else {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            
            if indexPath.section >= 2 {
                
                if let headerCell = headers[indexPath.section - 2] {
                    headerCell.dayLabel.textColor = UIColor.black
                    headerCell.dayLabel.textAlignment = .center
                }
                
                
            }
        }
        
        if let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }
    }

}
