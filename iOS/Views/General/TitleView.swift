//
//  TitleView.swift
//  Game On
//
//  Created by Eduardo Irias on 1/18/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

@IBDesignable
class TitleView: UIView {

    @IBInspectable var text: String = "" {
        didSet {
            titleLabel.text = text
        }
    }
    
    var lineView : UIView!
    var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        initView()
    }
    
    private func initView() {
        
        lineView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        lineView.backgroundColor = UIColor.lightGray
        lineView.alpha = 0.5
        self.addSubview(lineView)
       
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 00, width: 0, height: 42))
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: UIFontWeightHeavy)
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
