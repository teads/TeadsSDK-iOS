//
//  TeadsArticleViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class TeadsArticleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        Utils.teadsNavigationBar(navigationBar: navigationBar, navigationItem: navigationItem)
    }
    
}
