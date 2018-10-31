//
//  ViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let demoCellsInfoArray: [(String, Bool)] = [("inRead", false),
                                                ("inRead ScrollView", true),
                                                ("inRead WKWebView", true),
                                                ("inRead TableView", true),
                                                ("inRead CollectionView", true),
                                                ("inRead WebView embeded", false),
                                                ("inRead WKWebView in ScrollView", true),
                                                ("inRead WKWebView in TableView", true),
                                                ("inRead WKWebView in CollectionView", true),
                                                ("inRead Top", false),
                                                ("inRead Top implementation", true),
                                                ("Additional sample", false),
                                                ("AdMob Mediation", true)]
    
    let demoCellIdentifier = "DemoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellConfiguration = self.demoCellsInfoArray[indexPath.row]
        // Cell is a demo page
        if cellConfiguration.1 {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: cellConfiguration.0)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.demoCellsInfoArray.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: self.demoCellIdentifier)! as? DemoTableViewCell {
            cell.demoLabel.text = self.demoCellsInfoArray[indexPath.row].0
            // If cell is a demo page
            if self.demoCellsInfoArray[indexPath.row].1 {
                cell.accessoryType = .disclosureIndicator
            } else { // Cell is a title
                cell.selectionStyle = .none
                cell.contentView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
            }
            
            return cell
        }
        return UITableViewCell()
    }
}
