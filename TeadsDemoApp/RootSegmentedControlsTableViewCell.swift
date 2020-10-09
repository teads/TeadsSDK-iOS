//
//  RootSegmentedControlsTableViewCell.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 06/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class RootSegmentedControlsTableViewCell: UITableViewCell {

    @IBOutlet weak var horrizontalStackView: UIStackView!
    var didSelectValue: ((_ index: Int) -> Void)!
    
    override func prepareForReuse() {
        horrizontalStackView.subviews.forEach { (subview) in
            horrizontalStackView.removeArrangedSubview(subview)
        }
    }
    
    func addButtonToStackViewWithStyle(button: UIButton, index: Int, isButtonSelected: Bool) {
        resetNormalStyle(button: button)
        button.setTitleColor(.primary, for: .normal)
        button.setTitleColor(.appBackground, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.cornerRadius = 12
        horrizontalStackView.addArrangedSubview(button)
        button.tag = index
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        if isButtonSelected {
            selectButton(button: button, at: index)
        }
    }
    
    @objc func buttonClicked(_ sender: UIButton?) {
        if let button = sender {
            selectButton(button: button, at: button.tag)
        }
    }
    
    func selectButton(button: UIButton, at index: Int) {
        button.isSelected = true
        button.backgroundColor = .primary
        didSelectValue?(index)
    }
    
    func resetNormalStyle(button: UIButton) {
        button.backgroundColor = .appBackground
        button.isSelected = false
    }

}
