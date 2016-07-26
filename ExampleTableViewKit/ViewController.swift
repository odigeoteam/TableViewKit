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
        tableViewManager.registerCell(CustomCell.self)
        
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
            self.showPickerControl()
        }
        section.addItem(item)
        
        let dateItem = TableViewItem(title: "Birthday", subtitle: nil)
        dateItem.accessoryType = .DisclosureIndicator
        dateItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showDatePickerControl(item)
        }
        section.addItem(dateItem)
        
        let selectionItem = TableViewItem(title: "Selection", subtitle: nil)
        selectionItem.accessoryType = .DisclosureIndicator
        selectionItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showSelectionViewController()
        }
        section.addItem(selectionItem)
    }
    
    private func addSecondSection() {
        
        let personalSection = TableViewSection(headerTitle: "Personal Data")
        tableViewManager.addSection(personalSection)
        
        let customItem = CustomItem()
        customItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
        }
        personalSection.addItem(customItem)
    }
    
    func showPickerControl() {
        
        let numbers: [Int] = Array(0...10)
        
        let pickerControl = PickerControl(elements: [numbers, numbers, numbers], selectCallback: nil, cancelCallback: nil)
        pickerControl.title = "Passengers"
        pickerControl.selectValue(1, component: 0)
        pickerControl.selectCallback = { selection in
            print(selection)
        }
        pickerControl.presentPickerOnView(view)
        
        self.pickerControl = pickerControl
    }
    
    func showDatePickerControl(fromItem: TableViewItemProtocol) {
        
        let fromDate = NSDate(timeIntervalSinceNow: -4600000)
        let toDate = NSDate(timeIntervalSinceNow: 4600000)
        let pickerControl = PickerControl(datePickerMode: .Date, fromDate: fromDate, toDate: toDate, minuteInterval: 0, selectCallback: { selection in
            if let date = selection as? NSDate {
                print(date)
            }
        })
        pickerControl.title = "Birthday"
        pickerControl.presentPickerOnView(view)
        
        self.pickerControl = pickerControl
    }
    
    func showSelectionViewController() {
        
        var items: [SelectionItemProtocol] = []
        for index in 1 ... 10 {
            let item = SelectionItem(title: "Item \(index)", value: index)
            item.selected = index % 2 == 0
            items.append(item)
        }
        
        let selectionViewController = SelectionViewController(style: .Grouped, selectionType: .Multiple)
        selectionViewController.title = "Selection"
        selectionViewController.items = items
        selectionViewController.selectionHandler = { items in
            print(items.map { $0.title! })
        }
        navigationController?.pushViewController(selectionViewController, animated: true)
    }
    
    @objc private func validationAction() {
        
        if let error = tableViewManager.errors().first {
            print("\(error.localizedDescription) with error code: \(ValidatorErrorCode(rawValue: error.code)!)")
        }
        else {
            print("All Ok")
        }
    }
}

