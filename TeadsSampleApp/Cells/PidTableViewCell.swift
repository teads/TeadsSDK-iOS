//
//  PidTableViewCell.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 22/11/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit

class PidTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
        self.textField.text = "\(UserDefaults.standard.integer(forKey: "PID"))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let defaults = UserDefaults.standard
        if  let text = textField.text, !text.isEmpty {
            defaults.set(Int(text), forKey: "PID")
        } else {
            defaults.set(84242, forKey: "PID")
        }
    }
}
