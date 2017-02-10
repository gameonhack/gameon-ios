//
//  EditTableViewCell.swift
//  Game On
//
//  Created by Eduardo Irias on 2/9/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

@objc protocol EditTableViewCellDelegate {
    @objc optional func didEditedTextField(cell : EditTableViewCell, withInput input : String)
    @objc optional func didEditedTextView(cell : EditTableViewCell, withInput input : String)
}


class EditTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {

    weak var delegate : EditTableViewCellDelegate!
    
    var input : String {
        get {
            if let inputTextField = self.inputTextField {
                return inputTextField.text!
            }
            if let inputTextView = self.inputTextView {
                return inputTextView.text!
            }
            return ""
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var inputTextField: UITextField?
    @IBOutlet weak var inputTextView: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let inputTextField = inputTextField {
            inputTextField.delegate = self
        }
        if let inputTextView = inputTextView {
            inputTextView.delegate = self
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let didEdited = delegate.didEditedTextField {
            didEdited(self, textField.text!)
        }
        return true
    }
    
}
