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
    
    var pickerControl: PickerControl?

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
            self.showPickerControl()
        }
        section.addItem(item)
        
        let dateItem = TableViewItem(title: "Birthday", subtitle: nil)
        dateItem.accessoryType = .DisclosureIndicator
        dateItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showDatePickerControl()
        }
        section.addItem(dateItem)
        
        let selectionItem = TableViewItem(title: "Selection", subtitle: nil)
        selectionItem.accessoryType = .DisclosureIndicator
        selectionItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showPickerControl()
        }
        section.addItem(selectionItem)
        
        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Name"
        section.addItem(textFieldItem)
        
        tableViewManager.validate(textFieldItem) {
            $0.add(rule: ExistRule())
        }
        
        let textFieldItem2 = TextFieldItem()
        textFieldItem2.placeHolder = "Surname"
        section.addItem(textFieldItem2)
        
        tableViewManager.validate(textFieldItem2) {
            $0.add(rule: ExistRule())
        }

    }
    
    private func addSecondSection() {

        let section = TableViewSection(headerTitle: "Second Section")
        tableViewManager.addSection(section)

        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Place of birth"
        
        section.addItem(textFieldItem)
        
        tableViewManager.validate(textFieldItem) {
            $0.add(rule: ExistRule())
        }
    }
    
    private func showPickerControl() {
        
        var elements = [PickerItem]()
        
        let options = ["Option 1", "Option 2", "Option 3"]
        options.forEach { elements.append(PickerItem(title: $0, value: $0)) }
        
        let pickerControl = PickerControl(elements: elements, emptyFirstItem: true, selectCallback: { pickerControl, selectedElement in
            print(selectedElement)
            pickerControl.dismissPickerView()
            self.pickerControl = nil
        })
        pickerControl.presentPickerOnView(view)
        
        self.pickerControl = pickerControl
    }
    
    private func showDatePickerControl() {
        
        let toDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: 1, toDate: NSDate(), options: NSCalendarOptions.MatchNextTime)!
        let pickerDateControl = PickerControl(datePickerMode: .Date, fromDate: NSDate(), toDate: toDate, minuteInterval: 0, selectCallback: { pickerControl, date in
            
            pickerControl.dismissPickerView()
            print(date)
            
            self.pickerControl = nil
            
        }, cancelCallback: nil)
        pickerDateControl.presentPickerOnView(view)
        
        pickerControl = pickerDateControl
    }
    
    @objc private func validationAction() {
        guard let error = tableViewManager.errors.first else { return }
        print(error)
        
    }
}

