//
//  ViewController.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import UIKit
import TableViewKit

class FirstSection: Section {
    let vc: ViewController

    init(vc: ViewController) {
        self.vc = vc
        super.init()
        self.headerTitle = "First section title"
        self.footerTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta blandit interdum. In nec eleifend libero. Morbi maximus nulla non dapibus blandit"
        
        let item = CustomItem(title: "Passengers")
        let dateItem = CustomItem(title: "Birthday")
        let selectionItem = CustomItem(title: "Selection")
        let textFieldItem = TextFieldItem(placeHolder: "Name")
        textFieldItem.validation.add(rule: ExistRule())
        let textFieldItem2 = TextFieldItem(placeHolder: "Surname")
        textFieldItem2.validation.add(rule: ExistRule())
        
        item.onSelection = { item in
            item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
            self.vc.showPickerControl()
        }
        dateItem.accessoryType = .DisclosureIndicator
        dateItem.onSelection = { item in
            item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
            self.vc.showDatePickerControl()
        }
        selectionItem.accessoryType = .DisclosureIndicator
        selectionItem.onSelection = { item in
            item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
            self.vc.showPickerControl()
        }
        
        self.items.insertContentsOf([item, dateItem, selectionItem, textFieldItem, textFieldItem2], at: 0)
    }
}

class SecondSection: Section {
    
    override init() {
        super.init()
        self.headerTitle = "Second Section"
        
        let textFieldItem = TextFieldItem(placeHolder: "Place of birth")
        textFieldItem.validation.add(rule: ExistRule())
        
        self.items.insertContentsOf([textFieldItem], at: 0)
    }
}

class ViewController: UITableViewController {
    
    var tableViewManager: TableViewManager!
    var pickerControl: PickerControl?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewManager = TableViewManager(tableView: self.tableView, sections: [FirstSection(vc: self), SecondSection()])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .Plain, target: self, action: #selector(validationAction))
    }

    
    private func showPickerControl() {
        
        var elements = [PickerItem]()
        
        let options = ["Option 1", "Option 2", "Option 3"]
        options.forEach { elements.append(PickerItem(title: $0, value: $0)) }
        
        let pickerControl = PickerControl(elements: elements, selectCallback: { pickerControl, selectedElement in
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

