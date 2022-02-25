//
//  RootViewController.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 06/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: TeadsViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var selectionList = [inReadFormat, nativeFormat]
    
    private let headerCell = "RootHeaderCollectionReusableView"
    private let buttonCell = "RootButtonCollectionViewCell"
    private let imageViewButtonCell = "RootImageViewLabelCollectionViewCell"
    var adSelection: AdSelection = AdSelection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasTeadsArticleNavigationBar = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.reloadData()
    }
    
    func showSampleController(for integration: Integration) {
        let identifier = "\(adSelection.format.name)-\(adSelection.provider.name)-\(integration.name)"
        print(identifier)
        performSegue(withIdentifier: identifier.lowercased(), sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TeadsViewController else {
            return
        }
        destination.pid = pidForCreative()
    }
    
    private func pidForCreative() -> String {
        switch adSelection.provider.name {
        case .direct:
            switch adSelection.creation.name {
            case .landscape:
                return PID.directLandscape
            case .vertical:
                return PID.directVertical
            case .square:
                return PID.directSquare
            case .carousel:
                return PID.directCarousel
            case .custom:
                return PID.custom
            case .nativeDisplay:
                return PID.directNativeDisplay
            }
        case .admob:
            switch adSelection.creation.name {
            case .landscape:
                return PID.admobLandscape
            case .vertical:
                return PID.admobVertical
            case .square:
                return PID.admobSquare
            case .carousel:
                return PID.admobCarousel
            case .custom:
                return PID.custom
            case .nativeDisplay:
                return PID.admobNativeDisplay
            }
        case .mopub:
            switch adSelection.creation.name {
            case .landscape:
                return PID.mopubLandscape
            case .vertical:
                return PID.mopubVertical
            case .square:
                return PID.mopubSquare
            case .carousel:
                return PID.mopubCarousel
            case .custom:
                return PID.custom
            case .nativeDisplay:
                return PID.mopubNativeDisplay
            }
        case .sas:
            switch adSelection.creation.name {
            case .landscape:
                return PID.sasLandscape
            case .vertical:
                return PID.sasVertical
            case .square:
                return PID.sasSquare
            case .carousel:
                return PID.sasCarousel
            case .custom:
                return PID.custom
            case .nativeDisplay:
                return PID.directNativeDisplay
            }
        case .appLovin:
            switch adSelection.creation.name {
            case .landscape:
                return PID.appLovinLandscape
            case .vertical:
                return PID.appLovinVertical
            case .square:
                return PID.appLovinSquare
            case .carousel:
                return PID.appLovinCarousel
            case .custom:
                return PID.custom
            case .nativeDisplay:
                return PID.appLovinNativeDisplay
            }
        }
    }
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections = 0
        numberOfSections += selectionList.count > 0 ? 1 : 0
        numberOfSections += (selectionList.first(where: {$0.isSelected})?.providers.count ?? 0) > 0 ? 1 : 0
        numberOfSections += (selectionList.first(where: {$0.isSelected})?.providers.first(where: {$0.isSelected})?.integrations.count ?? 0) > 0 ? 1 : 0
        numberOfSections = numberOfSections == 1 ? 1 : numberOfSections + 1
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return selectionList.count
        case 1:
            return selectionList.first(where: {$0.isSelected})?.providers.count ?? 0
        case 2:
            return selectionList.first(where: {$0.isSelected})?.creativeTypes.count ?? 0
        case 3:
            return selectionList.first(where: {$0.isSelected})?.providers.first(where: {$0.isSelected})?.integrations.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? RootHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        switch indexPath.section {
        case 0:
            cell.label.text = "Formats"
        case 1:
            cell.label.text = "Providers"
        case 2:
            cell.label.text = "Creatives"
        case 3:
            cell.label.text = "Integrations"
        default:
            break
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCell, for: indexPath) as? RootButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            let cellValue = selectionList[indexPath.item]
            cell.label.text = cellValue.name.rawValue
            cell.isButtonSelected = cellValue.isSelected
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCell, for: indexPath) as? RootButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let cellValue = selectionList.first(where: {$0.isSelected})?.providers[indexPath.item] {
                cell.label.text = cellValue.name.rawValue
                cell.isButtonSelected = cellValue.isSelected
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCell, for: indexPath) as? RootButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let cellValue = selectionList.first(where: {$0.isSelected})?.creativeTypes[indexPath.item] {
                cell.label.text = cellValue.name.rawValue
                cell.isButtonSelected = cellValue.isSelected
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageViewButtonCell, for: indexPath) as? RootImageViewLabelCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let cellValue = selectionList.first(where: {$0.isSelected})?.providers.first(where: {$0.isSelected})?.integrations[indexPath.item] {
                cell.imageView.image = UIImage(named: cellValue.imageName)
                cell.label.text = cellValue.name
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            for i in 0..<selectionList.count {
                selectionList[i].isSelected = indexPath.item == i
                if indexPath.item == i {
                    adSelection.format = selectionList[i]
                    if let creation = adSelection.format.creativeTypes.first(where: { $0.isSelected }) {
                        adSelection.creation = creation
                    }
                    if let provider = adSelection.format.providers.first(where: { $0.isSelected }) {
                        adSelection.provider = provider
                    }
                }
            }
            collectionView.reloadData()
            if selectionList.first(where: {$0.isSelected})?.providers.count == 0 {
                let alert = UIAlertController(title: "Coming soon", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    let indexPath = IndexPath(item: 0, section: 0)
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                    self.collectionView(collectionView, didSelectItemAt: indexPath)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        case 1:
            for j in 0..<selectionList.count where selectionList[j].isSelected {
                for i in 0..<selectionList[j].providers.count {
                    selectionList[j].providers[i].isSelected = indexPath.item == i
                    if indexPath.item == i {
                        self.adSelection.provider = selectionList[j].providers[i]
                    }
                }
            }
            collectionView.reloadData()
        case 2:
            for j in 0..<selectionList.count where selectionList[j].isSelected {
                for i in 0..<selectionList[j].creativeTypes.count {
                    selectionList[j].creativeTypes[i].isSelected = indexPath.item == i
                    if indexPath.item == i {
                        if selectionList[j].creativeTypes[i].name == .custom {
                            pidAlert()
                        }
                        self.adSelection.creation = selectionList[j].creativeTypes[i]
                    }
                }
            }
            collectionView.reloadData()
        case 3:
            for j in 0..<selectionList.count where selectionList[j].isSelected {
                for i in 0..<selectionList[j].providers.count where selectionList[j].providers[i].isSelected {
                    for h in 0..<selectionList[j].providers[i].integrations.count {
                        if indexPath.item == h {
                            let integration = selectionList[j].providers[i].integrations[h]
                            showSampleController(for: integration)
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
    
}

extension RootViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            let spacing: CGFloat = 4
            let count: CGFloat = CGFloat(selectionList.count)
            let width = ((collectionView.bounds.width - 32) / count) - spacing * (count - 1)
            return CGSize(width: width, height: 32)
        case 1:
            let providerList = selectionList.first(where: {$0.isSelected})?.providers ?? []
            return getButtonButtonSize(buttonValues: providerList.map { $0.name.rawValue })
        case 2:
            let creativesTypeList = selectionList.first(where: {$0.isSelected})?.creativeTypes ?? []
            return getButtonButtonSize(buttonValues: creativesTypeList.map { $0.name.rawValue })
        case 3:
            let spacing: CGFloat = 16
            let width = ((collectionView.bounds.width - 32) / 2) - (spacing / 2)
            return CGSize(width: width, height: width)
        default:
            return CGSize.zero
        }
    }
    
    func pidAlert() {
        let alert = UIAlertController(title: "", message: "Enter your custom pid", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = PID.custom
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let text = textField?.text, !text.isEmpty {
                PID.custom = text
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getButtonWidth(buttonValues: [String]) -> Int {
        
        var width = 0
        buttonValues.forEach { (item) in
            width = max(width, Int(item.size(withAttributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
            ]).width))
        }
        return width + 16
    }
    
    func getButtonButtonSize(buttonValues: [String]) -> CGSize {
        
        let spacing: CGFloat = 4
        let availableWidth = Int(collectionView.bounds.width - 32)
        let buttonWidth =  min(getButtonWidth(buttonValues: buttonValues), availableWidth)
       
        let numberOfButtonOnRow = max(availableWidth / (buttonWidth+Int(spacing)), 1)
        let optimButtonWidth = availableWidth/numberOfButtonOnRow-numberOfButtonOnRow*Int(spacing)
        return CGSize(width: max(buttonWidth, optimButtonWidth), height: 32)
    }
}
