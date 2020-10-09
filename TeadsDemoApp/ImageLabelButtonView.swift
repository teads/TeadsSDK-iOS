//
//  ImageLabelButtonView.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 06/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation
import UIKit

protocol ImageLabelButtonViewDelegate: class {
    func didTap(button: ImageLabelButtonView)
}

@IBDesignable class ImageLabelButtonView: UIView {
    
    // MARK: - Properties
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    var label: UILabel!
    var imageView: UIImageView!
    weak var delegate : ImageLabelButtonViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - UI Setup
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Margins
        let margins = self.layoutMarginsGuide
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -12).isActive = true
        
        imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        label = UILabel()
        stackView.addArrangedSubview(label)
        label.textColor = .teadsGray
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didTap(button: self)
    }
}
