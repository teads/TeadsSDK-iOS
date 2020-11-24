//
//  FakeArticleView.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class FakeArticleView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let height = frame.height
        var fakeLineY: CGFloat = 10.0
        let spaceBetweenLine: CGFloat = 20
        while height > fakeLineY {
            let color: UIColor = UIColor.clear
            let drect = CGRect(x: 5, y: fakeLineY, width: frame.width - 10, height: 10)
            let bpath:UIBezierPath = UIBezierPath(roundedRect: drect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
            UIColor.fakeArticle.setFill()
            bpath.fill()
            color.set()
            bpath.stroke()
            fakeLineY += spaceBetweenLine
        }
    }
    

}
