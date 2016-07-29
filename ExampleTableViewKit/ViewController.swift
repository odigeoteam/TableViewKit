//
//  ViewController.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import UIKit
import TableViewKit

class ViewController: UITableViewController {
    
    var tableViewManager: TableViewManager!
    
    private var pickerControl: PickerControl?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewManager = TableViewManager(tableView: self.tableView, delegate: nil)
        
        addFirstSection()
        addSecondSection()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .Plain, target: self, action: #selector(validationAction))
    }
    
    private func addFirstSection() {
        
        let section = TableViewSection(headerTitle: "Section title")
        section.footerTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta blandit interdum. In nec eleifend libero. Morbi maximus nulla non dapibus blandit"
        tableViewManager.addSection(section)
        
        let item = TableViewItem(title: "Passengers", subtitle: nil)
        item.image = UIImage(named: "search")
        item.accessoryType = .DisclosureIndicator
        item.selectionHandler = { item in
            item.deselectRowAnimated(true)
            //self.showPickerControl()
        }
        section.addItem(item)
        
        let dateItem = TableViewItem(title: "Birthday", subtitle: nil)
        dateItem.accessoryType = .DisclosureIndicator
        dateItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            //self.showDatePickerControl(item)
        }
        section.addItem(dateItem)
        
        let selectionItem = TableViewItem(title: "Selection", subtitle: nil)
        selectionItem.accessoryType = .DisclosureIndicator
        selectionItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            //self.showSelectionViewController()
        }
        section.addItem(selectionItem)
        
        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Name"
        section.addItem(textFieldItem)
        
        tableViewManager.validate(textFieldItem) { validation in
            var validation = validation
            validation.add(rule: NameRule())
            return validation
        }
        
        let textFieldItem2 = TextFieldItem()
        textFieldItem2.placeHolder = "Surname"
        section.addItem(textFieldItem2)
        
        tableViewManager.validate(textFieldItem2) { validation in
            var validation = validation
            validation.add(rule: NameRule())
            return validation
        }

    }
    
    private func addSecondSection() {

        let section = TableViewSection(headerTitle: "Section second")
        section.footerTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta blandit interdum. In nec eleifend libero. Morbi maximus nulla non dapibus blandit"
        tableViewManager.addSection(section)

        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Place of birth"
        
        section.addItem(textFieldItem)
        
        tableViewManager.validate(textFieldItem) { validation in
            var validation = validation
            validation.add(rule: NameRule())
            return validation
        }
    }
    
    @objc private func validationAction() {
        guard let error = tableViewManager.errors.first else { return }
//        let item = error.identifier as! CanShowError
//        item.show(error: error)
        print(error)
        
    }
}

