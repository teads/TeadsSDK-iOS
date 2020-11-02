//
//  String.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
}
