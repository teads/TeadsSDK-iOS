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
    private var selectionList = [inReadFormat, nativeFormat]
    
    private let headerCell = "RootHeaderCollectionReusableView"
    private let buttonCell = "RootButtonCollectionViewCell"
    private let imageViewButtonCell = "RootImageViewLabelCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    func showDemoController(withIntegration integration: String) {
        guard let selectedFormat = selectionList.first(where: {$0.isSelected})?.name,
              let selectedProvider = selectionList.first(where: {$0.isSelected})?.providers.first(where: {$0.isSelected})?.name else {
            return
        }
        let identifier = "\(selectedFormat)-\(selectedProvider)-\(integration)"
        performSegue(withIdentifier: identifier.lowercased(), sender: self)
    }

}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections = 0
        numberOfSections += selectionList.count > 0 ? 1 : 0
        numberOfSections += (selectionList.first(where: {$0.isSelected})?.providers.count ?? 0) > 0 ? 1 : 0
        numberOfSections += (selectionList.first(where: {$0.isSelected})?.providers.first(where: {$0.isSelected})?.integrations.count ?? 0) > 0 ? 1 : 0
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return selectionList.count
        case 1:
            return selectionList.first(where: {$0.isSelected})?.providers.count ?? 0
        case 2:
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
            cell.label.text = cellValue.name
            cell.isSelected = cellValue.isSelected
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCell, for: indexPath) as? RootButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let cellValue = selectionList.first(where: {$0.isSelected})?.providers[indexPath.item] {
                cell.label.text = cellValue.name
                cell.isSelected = cellValue.isSelected
            }
            return cell
        case 2:
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
                }
            }
            collectionView.reloadData()
        case 2:
            for j in 0..<selectionList.count where selectionList[j].isSelected {
                for i in 0..<selectionList[j].providers.count where selectionList[j].providers[i].isSelected {
                    for h in 0..<selectionList[j].providers[i].integrations.count {
                        if indexPath.item == h {
                            showDemoController(withIntegration: selectionList[j].providers[i].integrations[h].name)
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
            let spacing: CGFloat = 4
            let count: CGFloat = CGFloat(selectionList.first(where: {$0.isSelected})?.providers.count ?? 0)
            let width = ((collectionView.bounds.width - 32) / count) - spacing * (count - 1)
            return CGSize(width: width, height: 32)
        case 2:
            let spacing: CGFloat = 16
            let width = ((collectionView.bounds.width - 32) / 2) - (spacing / 2)
            return CGSize(width: width, height: width)
        default:
            return CGSize.zero
        }
    }
    
}
