//
//  TeadsLogoUIView.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import UIKit

final class TeadsLogoUIView: UILabel {
    init(dark: Bool) {
        super.init(frame: .zero)
        text = "Teads SDK Demo (UIKit)"
        font = .systemFont(ofSize: 17, weight: .bold)
        textColor = dark ? .white : .black
        textAlignment = .center
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
