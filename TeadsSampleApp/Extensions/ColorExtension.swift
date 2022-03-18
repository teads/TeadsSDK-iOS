//
//  ColorExtension.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 06/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let appText = UIColor(named: "AppTextColor") ?? UIColor.clear
    static let appBackground = UIColor(named: "AppBackgroundColor") ?? UIColor.clear
    static let primary = UIColor(named: "PrimaryColor") ?? UIColor.clear
    static let lightBlue = UIColor(named: "LightBlueColor") ?? UIColor.clear
    static let teadsBlue = UIColor(named: "TeadsBlueColor") ?? UIColor.clear
    static let teadsPurple = UIColor(named: "TeadsPurpleColor") ?? UIColor.clear
    static let teadsGray = UIColor(named: "TeadsGrayColor") ?? UIColor.clear
    static let fakeArticle = UIColor(named: "FakeArticleColor") ?? UIColor.clear
    static let cellBorder = UIColor(named: "CellBorderColor") ?? UIColor.clear

    func getRedValue() -> CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return red
    }

    func getBlueValue() -> CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return blue
    }

    func getGreenValue() -> CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return green
    }
}
