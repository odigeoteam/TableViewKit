//
//  ViewController.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import UIKit
import TableViewKit

struct Configuration {
    let vc: ViewController
    
    let item = BaseItem(title: "Passengers")
    let dateItem = BaseItem(title: "Birthday")
    let selectionItem = BaseItem(title: "Selection")
    let textFieldItem = TextFieldItem()
    let textFieldItem2 = TextFieldItem()
    let specialItem = BaseItem(title: "Special")


    
    
    var normalState: [Section] {
        mutating get {
            return [firstSection, secondSection]
        }
    }
    
    var specialState: [Section] {
        mutating get {
            return [modifiedSection, secondSection]
        }
    }
    
    init(vc: ViewController) {
        self.vc = vc
        
        self.item.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.vc.showPickerControl()
        }
        self.dateItem.accessoryType = .DisclosureIndicator
        self.dateItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.vc.showDatePickerControl()
        }
        self.selectionItem.accessoryType = .DisclosureIndicator
        self.selectionItem.selectionHandler = { item in
            item.deselectRowAnimated(true)
            self.vc.showPickerControl()
        }
        
        self.textFieldItem.placeHolder = "Name"
        self.vc.tableViewManager.validate(self.textFieldItem) {
            $0.add(rule: ExistRule())
        }
        
        self.textFieldItem2.placeHolder = "Surname"
        self.vc.tableViewManager.validate(self.textFieldItem2) {
            $0.add(rule: ExistRule())
        }

    }
    
    
    
    private lazy var sharedSection: Section = {
        let section = Section()
        section.headerTitle = "Section title"
        section.footerTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta blandit interdum. In nec eleifend libero. Morbi maximus nulla non dapibus blandit"
        return section
    }()
    
    private var modifiedSection: Section {
        mutating get {
            let section = self.sharedSection
            section.items.replace([self.dateItem, self.textFieldItem, self.specialItem, self.textFieldItem2], performDiff: true)
            
            return section
        }
    }
    
    private var firstSection: Section {
        mutating get {
            let section = self.sharedSection
            section.items.replace([self.item, self.dateItem, self.selectionItem, self.textFieldItem, self.textFieldItem2], performDiff: true)
            return section
        }
    }
    
    private lazy var secondSection: Section = {
        let textFieldItem = TextFieldItem()
        textFieldItem.placeHolder = "Place of birth"
        self.vc.tableViewManager.validate(textFieldItem) {
            $0.add(rule: ExistRule())
        }
        
        let section = Section(items: [textFieldItem])
        section.headerTitle = "Second Section"
        return section
    }()


}

class ViewController: UITableViewController {
    
    var tableViewManager: TableViewManager!
    var configuration: Configuration!
    var pickerControl: PickerControl?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewManager = TableViewManager(tableView: self.tableView)
        configuration = Configuration.init(vc: self)
        tableViewManager.sections.insertContentsOf(configuration.normalState, at: 0)
        
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
        if (arc4random_uniform(2) == 0) {
            tableViewManager.sections.replace(configuration.normalState, performDiff: true)
        } else {
            tableViewManager.sections.replace(configuration.specialState, performDiff: true)
        }
        guard let error = tableViewManager.errors.first else { return }
        print(error)
        
    }
}

