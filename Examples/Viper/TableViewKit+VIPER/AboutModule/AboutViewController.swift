//
//  AboutViewController.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 06/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import UIKit
import TableViewKit

class AboutViewController: UITableViewController, AboutViewControllerProtocol {
    
    var presenter: AboutPresenterProtocol?
    var tableViewManager: TableViewManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
        
        tableViewManager = TableViewManager(tableView: self.tableView)
        tableViewManager?.sections.append(HelpCenterSection(presenter: presenter))
        tableViewManager?.sections.append(MoreAboutSection(presenter: presenter, manager: tableViewManager))
    }
    
    func presentMessage(_ message: String, title: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
