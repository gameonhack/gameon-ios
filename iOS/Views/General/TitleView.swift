//
//  TitleView.swift
//  Game On
//
//  Created by Eduardo Irias on 1/18/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class TitleView: UIView {

    @IBInspectable var text: String = "" {
        didSet {
            titleLabel.text = text
        }
    }
    
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
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        lineView.backgroundColor = UIColor.lightGray
        lineView.alpha = 0.5
        self.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 00, width: 0, height: 0))
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: UIFontWeightHeavy)
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(28)
            make.left.equalTo(20)
            make.right.equalTo(0)
        }
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
