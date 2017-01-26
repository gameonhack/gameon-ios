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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1 ? 1 : 0
    }
    
    func getCellIdentifier(index : Int) -> String {
        switch index {
        case 0:
            return "EventHeaderDecorationCell"
        case 1:
            return "EventHeaderCell"
        default:
            return "EventCell"
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

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 215.0
        case 1:
            let aboutLabelHeight : CGFloat = 166.0
            let frameSize = CGSize(width: self.view.frame.width - 40.0, height: 1000.0)
            let aboutTextViewSize = event.caption.boundingRect(with: frameSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 22)], context: nil)
            return aboutLabelHeight + aboutTextViewSize.height
        default:
            return 100.0
        }
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
