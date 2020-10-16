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
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectionList = [Format]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectionList = [inReadFormat, nativeFormat]
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
        let selectedFormats = selectionList.flatMap({$0.providers.filter({$0.isSelected})})
        let selectedFormatsLabels = selectedFormats.map({$0.name.lowercased()})
        let identifier = selectedFormatsLabels.joined(separator: "-")
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    func setupRootSegmentedControlsTableViewCell(cell: RootSegmentedControlsTableViewCell, indexPath: IndexPath) {
        var buttons = [UIButton]()
        selectionList[indexPath.section].providers.enumerated().forEach { (index, value) in
            let button = UIButton()
            button.setTitle(value.name, for: .normal)
            cell.addButtonToStackViewWithStyle(button: button, index: index, isButtonSelected: value.isSelected)
            buttons.append(button)
        }
        cell.didSelectValue = { [weak self] index in
            if let pastIndex: Int = self?.selectionList[indexPath.section].providers.firstIndex(where: {$0.isSelected == true}), pastIndex != index {
                self?.selectionList[indexPath.section].providers[pastIndex].isSelected = false
                cell.resetNormalStyle(button: buttons[pastIndex])
                self?.selectionList[indexPath.section].providers[index].isSelected = true
            }
        }
    }
    
    func setupRootButtonIconLabelTableViewCell(cell: RootButtonIconLabelTableViewCell, indexPath: IndexPath) {
        guard let integrations = selectionList[indexPath.section].providers.filter({$0.isSelected}).first?.integrations else {
            return
        }
        let firstCardIndex = indexPath.row + indexPath.row
        let secondCardIndex = firstCardIndex + 1
        let firstCardValue = integrations[firstCardIndex]
        cell.firstCard.label.text = firstCardValue.name
        cell.firstCard.imageView.image = UIImage(named: firstCardValue.imageName)
        cell.firstCard.tag = firstCardIndex
        cell.firstCard.delegate = self
        
        if integrations.indices.contains(secondCardIndex) {
            let secondCardValue = integrations[secondCardIndex]
            cell.secondCard.label.text = secondCardValue.name
            cell.secondCard.imageView.image = UIImage(named: secondCardValue.imageName)
            cell.secondCard.tag = secondCardIndex
            cell.secondCard.delegate = self
        } else {
            cell.secondCard.isHidden = true
        }
    }

}

extension RootViewController: UICollectionViewDelegate {
    
}

extension RootViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rootCell", for: indexPath) as! RootSectionCollectionViewCell
            cell.cellLabel.text = "Format"
            cell.buttonsStackView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            selectionList.enumerated().forEach { (index, format) in
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
                button.backgroundColor = format.isSelected ? .primary : .white
                button.layer.borderColor = UIColor.primary.cgColor
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 1
                button.setTitle(format.name, for: .normal)
                button.setTitleColor(format.isSelected ? .teadsGray: .primary, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(formatButtonClicked), for: .touchUpInside)
                cell.buttonsStackView.addArrangedSubview(button)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rootCell", for: indexPath) as! RootSectionCollectionViewCell
            cell.cellLabel.text = "Provider"
            cell.buttonsStackView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            let formatSelected = selectionList.filter({$0.isSelected}).first
            formatSelected?.providers.enumerated().forEach { (index, provider) in
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
                button.tag = index
                button.backgroundColor = provider.isSelected ? .primary : .white
                button.layer.borderColor = UIColor.primary.cgColor
                button.setTitleColor(provider.isSelected ? .teadsGray: .primary, for: .normal)
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 1
                button.setTitle(provider.name, for: .normal)
                button.addTarget(self, action: #selector(providerButtonClicked), for: .touchUpInside)
                cell.buttonsStackView.addArrangedSubview(button)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rootCell", for: indexPath) as! RootSectionCollectionViewCell
            cell.cellLabel.text = ""
            cell.buttonsStackView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            guard let integrationsSelected = selectionList.filter({$0.isSelected}).first?.providers.filter({$0.isSelected}).first?.integrations else {
                return cell
            }
            cell.backgroundColor = .blue
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: cell.buttonsStackView.bounds.height))
            cell.buttonsStackView.addSubview(scrollView)
            scrollView.backgroundColor = .green
            let height = ceilf(Float(integrationsSelected.count/2)) * 100
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(height))
            integrationsSelected.enumerated().forEach({ (index, integration) in
                let integrationView = UIView(frame: CGRect(x: (index % 2) * Int(scrollView.bounds.width)/2 , y: Int(floor(Double(index/2))) * 110, width: 150, height: 100))
                integrationView.backgroundColor = .red
                scrollView.addSubview(integrationView)
            })
            return cell
        }
    }
    
    @objc func formatButtonClicked(_ sender: UIButton) {
        for j in 0..<selectionList.count {
            selectionList[j].isSelected = sender.tag == j
        }
        collectionView.reloadData()
    }
    
    @objc func providerButtonClicked(_ sender: UIButton) {
        for j in 0..<selectionList.count where selectionList[j].isSelected {
            for i in 0..<selectionList[j].providers.count {
                selectionList[j].providers[i].isSelected = sender.tag == i
            }
        }
        collectionView.reloadData()
    }
}

extension RootViewController: UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: UIScreen.main.bounds.width, height: 400)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 100.0)
    }
}

extension RootViewController: ImageLabelButtonViewDelegate {
    func didTap(button: ImageLabelButtonView) {
        selectionList[2].providers[button.tag].isSelected = true
        showDemoController()
    }
}
