//
//  TeadsAdEmbededCollectionViewCell.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 04/10/2017.
//  Copyright © 2017 Jérémy Grosjean. All rights reserved.
//

import UIKit
import WebKit

class TeadsAdEmbededCollectionViewCell: UICollectionViewCell {
    
    weak var webView: WKWebView? {
        didSet {
            if webView != nil {
                self.contentView.addSubview(webView!)
            }
        }
    }
}
