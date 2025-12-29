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
    @IBOutlet var collectionView: UICollectionView!
    private var selectionList = [inReadFormat, nativeFormat]

    private let headerCell = "RootHeaderCollectionReusableView"
    private let buttonCell = "RootButtonCollectionViewCell"
    private let imageViewButtonCell = "RootImageViewLabelCollectionViewCell"
    var adSelection: AdSelection = .init()

    private let validationModeKey = "TeadsValidationModeEnabled"

    override func viewDidLoad() {
        super.viewDidLoad()
        hasTeadsArticleNavigationBar = false

        // Load validation mode from UserDefaults
        validationModeEnabled = UserDefaults.standard.object(forKey: validationModeKey) as? Bool ?? true

        // Register validation toggle cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ValidationToggleCell")

        // Register showcase button cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ShowcaseButtonCell")
    }

    @objc private func showMediaFeedShowcase() {
        let showcase = MediaFeedShowcaseViewController()
        showcase.validationModeEnabled = validationModeEnabled
        navigationController?.pushViewController(showcase, animated: true)
    }

    @objc private func validationModeToggled(_ sender: UISwitch) {
        validationModeEnabled = sender.isOn
        UserDefaults.standard.set(validationModeEnabled, forKey: validationModeKey)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.reloadData()
    }

    func showSampleController(for integration: Integration) {
        let identifier = "\(adSelection.format.name)-\(adSelection.provider.name)-\(integration.name)"
            .lowercased()
        performSegue(withIdentifier: identifier, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // Handle TeadsViewController subclasses
        if let destination = segue.destination as? TeadsViewController {
            destination.pid = pidForCreative()
            destination.validationModeEnabled = validationModeEnabled

            if let appLovinViewController = destination as? AppLovinViewController,
               [CreativeTypeName.appLovinMRECCarousel, CreativeTypeName.appLovinMRECSquare, CreativeTypeName.appLovinMRECLandscape, CreativeTypeName.appLovinMRECVertical].contains(adSelection.creation.name) {
                appLovinViewController.isMREC = true
            }
            return
        }

        // Handle InReadPageViewController separately (doesn't inherit from TeadsViewController)
        if let destination = segue.destination as? InReadPageViewController {
            destination.pid = pidForCreative()
            destination.validationModeEnabled = validationModeEnabled
        }
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
                    default: return ""
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
                    default: return ""
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
                    default: return ""
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
                    case .appLovinMRECLandscape:
                        return PID.appLovinLandscapeMREC
                    case .appLovinMRECVertical:
                        return PID.appLovinVerticalMREC
                    case .appLovinMRECSquare:
                        return PID.appLovinSquareMREC
                    case .appLovinMRECCarousel:
                        return PID.appLovinCarouselMREC
                    case .custom:
                        return PID.custom
                    case .nativeDisplay:
                        return PID.appLovinNativeDisplay
                }
        }
    }
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        var numberOfSections = 0
        numberOfSections += selectionList.count > 0 ? 1 : 0
        numberOfSections += (selectionList.first(where: { $0.isSelected })?.providers.count ?? 0) > 0 ? 1 : 0
        numberOfSections += (selectionList.first(where: { $0.isSelected })?.providers.first(where: { $0.isSelected })?.integrations.count ?? 0) > 0 ? 1 : 0
        numberOfSections = numberOfSections == 1 ? 1 : numberOfSections + 1
        numberOfSections += 1 // Add showcase section after integrations
        numberOfSections += 1 // Add validation toggle section at the end
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Check if this is the validation toggle section (last section)
        let totalSections = numberOfSections(in: collectionView)
        if section == totalSections - 1 {
            return 1 // Validation toggle cell
        }

        // Check if this is the showcase section (second to last)
        if section == totalSections - 2 {
            return 1 // Showcase button
        }

        switch section {
            case 0:
                return selectionList.count
            case 1:
                return selectionList.first(where: { $0.isSelected })?.providers.count ?? 0
            case 2:
                return selectionList.first(where: { $0.isSelected })?.creativeTypes.count ?? 0
            case 3:
                return selectionList.first(where: { $0.isSelected })?.providers.first(where: { $0.isSelected })?.integrations.count ?? 0
            default:
                return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? RootHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }

        // Check if this is the validation toggle section (last section)
        let totalSections = numberOfSections(in: collectionView)
        if indexPath.section == totalSections - 1 {
            cell.label.text = "Settings"
            return cell
        }

        // Check if this is the showcase section (second to last)
        if indexPath.section == totalSections - 2 {
            cell.label.text = "Showcase"
            return cell
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
        // Check if this is the validation toggle section (last section)
        let totalSections = numberOfSections(in: collectionView)
        if indexPath.section == totalSections - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ValidationToggleCell", for: indexPath)

            // Clear any existing subviews
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }

            // Create horizontal stack view
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 12
            stackView.translatesAutoresizingMaskIntoConstraints = false

            // Create label
            let label = UILabel()
            label.text = "Validation Mode"
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 16)

            // Create switch
            let switchControl = UISwitch()
            switchControl.isOn = validationModeEnabled
            switchControl.tag = indexPath.item
            switchControl.addTarget(self, action: #selector(validationModeToggled(_:)), for: .valueChanged)

            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(switchControl)

            cell.contentView.addSubview(stackView)

            // Add constraints
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ])

            return cell
        }

        // Check if this is the showcase section (second to last)
        if indexPath.section == totalSections - 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseButtonCell", for: indexPath)

            // Clear any existing subviews
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }

            // Create button
            let button = UIButton(type: .system)
            button.setTitle("📺 Media + Feed Showcase", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(showMediaFeedShowcase), for: .touchUpInside)

            cell.contentView.addSubview(button)

            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                button.heightAnchor.constraint(equalToConstant: 50),
            ])

            return cell
        }

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
                if let cellValue = selectionList.first(where: { $0.isSelected })?.providers[indexPath.item] {
                    cell.label.text = cellValue.name.rawValue
                    cell.isButtonSelected = cellValue.isSelected
                }
                return cell
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCell, for: indexPath) as? RootButtonCollectionViewCell else {
                    return UICollectionViewCell()
                }
                if let cellValue = selectionList.first(where: { $0.isSelected })?.creativeTypes[indexPath.item] {
                    cell.label.text = cellValue.name.rawValue
                    cell.isButtonSelected = cellValue.isSelected
                }
                return cell
            case 3:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageViewButtonCell, for: indexPath) as? RootImageViewLabelCollectionViewCell else {
                    return UICollectionViewCell()
                }
                if let cellValue = selectionList.first(where: { $0.isSelected })?.providers.first(where: { $0.isSelected })?.integrations[indexPath.item] {
                    cell.imageView.image = UIImage(named: cellValue.imageName)
                    cell.label.text = cellValue.name
                }
                return cell
            default:
                return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check if this is the showcase or validation section - no action needed
        let totalSections = numberOfSections(in: collectionView)
        if indexPath.section == totalSections - 1 || indexPath.section == totalSections - 2 {
            return
        }

        switch indexPath.section {
            case 0:
                for i in 0 ..< selectionList.count {
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
                if selectionList.first(where: { $0.isSelected })?.providers.count == 0 {
                    let alert = UIAlertController(title: "Coming soon", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        let indexPath = IndexPath(item: 0, section: 0)
                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                        self.collectionView(collectionView, didSelectItemAt: indexPath)
                    }))
                    present(alert, animated: true, completion: nil)
                }
            case 1:
                for j in 0 ..< selectionList.count where selectionList[j].isSelected {
                    for i in 0 ..< selectionList[j].providers.count {
                        selectionList[j].providers[i].isSelected = indexPath.item == i
                        if indexPath.item == i {
                            self.adSelection.provider = selectionList[j].providers[i]
                        }
                    }
                }

                // Change creative type for AppLovin setup due to Banner vs MREC integration
                if adSelection.provider == inReadAppLovinProvider {
                    selectionList[0].creativeTypes = appLovinInReadCreativeTypes
                } else {
                    selectionList[0].creativeTypes = defaultInReadCreativeTypes
                }

                collectionView.reloadData()
            case 2:
                for j in 0 ..< selectionList.count where selectionList[j].isSelected {
                    for i in 0 ..< selectionList[j].creativeTypes.count {
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
                for j in 0 ..< selectionList.count where selectionList[j].isSelected {
                    for i in 0 ..< selectionList[j].providers.count where selectionList[j].providers[i].isSelected {
                        for h in 0 ..< selectionList[j].providers[i].integrations.count {
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

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}

extension RootViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Check if this is the validation toggle section (last section)
        let totalSections = numberOfSections(in: collectionView)
        if indexPath.section == totalSections - 1 {
            return CGSize(width: collectionView.bounds.width - 32, height: 60)
        }

        // Check if this is the showcase section (second to last)
        if indexPath.section == totalSections - 2 {
            return CGSize(width: collectionView.bounds.width - 32, height: 66)
        }

        switch indexPath.section {
            case 0:
                let spacing: CGFloat = 4
                let count: CGFloat = .init(selectionList.count)
                let width = ((collectionView.bounds.width - 32) / count) - spacing * (count - 1)
                return CGSize(width: width, height: 32)
            case 1:
                let providerList = selectionList.first(where: { $0.isSelected })?.providers ?? []
                return getButtonButtonSize(buttonValues: providerList.map { $0.name.rawValue })
            case 2:
                let creativesTypeList = selectionList.first(where: { $0.isSelected })?.creativeTypes ?? []
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

        alert.addTextField { textField in
            textField.text = PID.custom
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields![0]
            if let text = textField?.text, !text.isEmpty {
                PID.custom = text
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func getButtonWidth(buttonValues: [String]) -> Int {
        var width = 0
        for item in buttonValues {
            width = max(width, Int(item.size(withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            ]).width))
        }
        return width + 16
    }

    func getButtonButtonSize(buttonValues: [String]) -> CGSize {
        let spacing: CGFloat = 4
        let availableWidth = Int(collectionView.bounds.width - 32)
        let buttonWidth = min(getButtonWidth(buttonValues: buttonValues), availableWidth)

        let numberOfButtonOnRow = max(availableWidth / (buttonWidth + Int(spacing)), 1)
        let optimButtonWidth = availableWidth / numberOfButtonOnRow - numberOfButtonOnRow * Int(spacing)
        return CGSize(width: max(buttonWidth, optimButtonWidth), height: 32)
    }
}
