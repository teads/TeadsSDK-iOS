//
//  UIView-extension.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 18/03/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import UIKit

extension UIView {
    static func loadNib(nibName name: String? = nil) -> Self? {
        let nibName = name ?? String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? Self
    }
}
