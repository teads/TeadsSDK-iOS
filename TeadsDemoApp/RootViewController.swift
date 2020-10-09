//
//  RootViewController.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 06/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var selectionList = [Format]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectionList = [
            Format(header: "Format", values: [
                FormatValue(label: "inRead", isSelected: true),
                FormatValue(label: "Native", isSelected: false)
            ]),
            Format(header: "Provider", values: [
                FormatValue(label: "Direct", isSelected: true),
                FormatValue(label: "Admob", isSelected: false),
                FormatValue(label: "Mopub", isSelected: false)
            ]),
            Format(header: "Integration", values: [
                FormatValue(label: "ScrollView", isSelected: false),
                FormatValue(label: "TableView", isSelected: false),
                FormatValue(label: "CollectionView", isSelected: false),
                FormatValue(label: "WebView", isSelected: false)
            ])
        ]
        setNavigationBarImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNavigationBarImage()
    }
    
    func setNavigationBarImage() {
        var image = "Teads-Demo-App-black"
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                image = "Teads-Demo-App-white"
            }
        }
        let logo = UIImage(named: image)
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navigationItem.titleView = imageView
    }
    
    func showDemoController() {
        let selectedFormats = selectionList.flatMap({$0.values.filter({$0.isSelected})})
        let selectedFormatsLabels = selectedFormats.map({$0.label.lowercased()})
        let identifier = selectedFormatsLabels.joined(separator: "-")
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setupRootSegmentedControlsTableViewCell(cell: RootSegmentedControlsTableViewCell, indexPath: IndexPath) {
        var buttons = [UIButton]()
        selectionList[indexPath.section].values.enumerated().forEach { (index, value) in
            let button = UIButton()
            button.setTitle(value.label, for: .normal)
            cell.addButtonToStackViewWithStyle(button: button, index: index, isButtonSelected: value.isSelected)
            buttons.append(button)
        }
        cell.didSelectValue = { [weak self] index in
            if let pastIndex: Int = self?.selectionList[indexPath.section].values.firstIndex(where: {$0.isSelected == true}), pastIndex != index {
                self?.selectionList[indexPath.section].values[pastIndex].isSelected = false
                cell.resetNormalStyle(button: buttons[pastIndex])
                self?.selectionList[indexPath.section].values[index].isSelected = true
            }
        }
    }
    
    func setupRootButtonIconLabelTableViewCell(cell: RootButtonIconLabelTableViewCell, indexPath: IndexPath) {
        let values = selectionList[indexPath.section].values
        let firstCardIndex = indexPath.row + indexPath.row
        let secondCardIndex = firstCardIndex + 1
        let firstCardValue = values[firstCardIndex]
        cell.firstCard.label.text = firstCardValue.label
        cell.firstCard.imageView.image = UIImage(named: firstCardValue.label)
        cell.firstCard.tag = firstCardIndex
        cell.firstCard.delegate = self
        
        if values.indices.contains(secondCardIndex) {
            let secondCardValue = values[secondCardIndex]
            cell.secondCard.label.text = secondCardValue.label
            cell.secondCard.imageView.image = UIImage(named: secondCardValue.label)
            cell.secondCard.tag = secondCardIndex
            cell.secondCard.delegate = self
        } else {
            cell.secondCard.isHidden = true
        }
    }

}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "RootHeaderTableViewCell") as? RootHeaderTableViewCell else {
            return nil
        }
        headerCell.label.text = selectionList[section].header
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            let count: Double = ceil(Double(selectionList[section].values.count) / 2)
            return Int(count)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0, 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RootSegmentedControlsTableViewCell") as? RootSegmentedControlsTableViewCell else {
                return UITableViewCell()
            }
            setupRootSegmentedControlsTableViewCell(cell: cell, indexPath: indexPath)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RootButtonIconLabelTableViewCell") as? RootButtonIconLabelTableViewCell else {
                return UITableViewCell()
            }
            setupRootButtonIconLabelTableViewCell(cell: cell, indexPath: indexPath)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension RootViewController: ImageLabelButtonViewDelegate {
    func didTap(button: ImageLabelButtonView) {
        selectionList[2].values[button.tag].isSelected = true
        showDemoController()
    }
}
