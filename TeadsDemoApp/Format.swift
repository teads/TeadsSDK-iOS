//
//  Format.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 09/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation

struct Format {
    let header: String
    var values: [FormatValue]
}

struct FormatValue {
    let label: String
    var isSelected: Bool
}
