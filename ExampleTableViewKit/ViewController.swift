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
    
    var sections: [Section] {
        get {
            return [firstSection(), secondSection()]
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewManager = TableViewManager(tableView: self.tableView)
        tableViewManager.append(sections)
        tableViewManager.register()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .Plain, target: self, action: #selector(validationAction))
    }
    
    private func firstSection() -> Section {

        let item = BaseItem(title: "Passengers")
        item.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showPickerControl()
        }
        let dateItem = BaseItem(title: "Birthday")
        dateItem.accessoryType = .DisclosureIndicator
        dateItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showDatePickerControl()
        }
        let selectionItem = BaseItem(title: "Selection")
        selectionItem.accessoryType = .DisclosureIndicator
        selectionItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.showPickerControl()
        }
        
        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Name"
        tableViewManager.validate(textFieldItem) {
            $0.add(rule: ExistRule())
        }
        
        let textFieldItem2 = TextFieldItem()
        textFieldItem2.placeHolder = "Surname"
        tableViewManager.validate(textFieldItem2) {
            $0.add(rule: ExistRule())
        }
        
        let section = Section(items: [item, dateItem, selectionItem, textFieldItem, textFieldItem2])
        section.headerTitle = "Section title"
        section.footerTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta blandit interdum. In nec eleifend libero. Morbi maximus nulla non dapibus blandit"
        return section
    }
    
    private func secondSection() -> Section {

        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Place of birth"
        tableViewManager.validate(textFieldItem) {
            $0.add(rule: ExistRule())
        }
        
        let section = Section(items: [textFieldItem])
        section.headerTitle = "Second Section"
        return section
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

