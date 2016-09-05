//
//  ViewController.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import UIKit
import TableViewKit
import ReactiveKit

class FirstSection: Section {
    var items: CollectionProperty<[ItemProtocol]> = CollectionProperty([])

    let vc: ViewController
    
    internal var header: HeaderFooter? = CustomHeaderItem(title: "First Section")
    internal var footer: HeaderFooter? = CustomHeaderItem(title: "Section Footer\nHola")

    required init(vc: ViewController) {
        self.vc = vc
        
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
    var items: CollectionProperty<[ItemProtocol]> = CollectionProperty([])

    internal var header: HeaderFooter? = CustomHeaderItem(title: "Second Section")
    
    let vc: ViewController

    required init(vc: ViewController) {
        self.vc = vc
        
        let total: [Int] = Array(1...100)
        let items = total.map({ (index) -> ItemProtocol in
            if (index % 2 == 0) {
                let item = TextFieldItem(placeHolder: "Textfield \(index)")
                return item
            } else {
                let item = CustomItem(title: "Label  \(index)")
                item.onSelection = { item in
                    item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
                }
                return item
            }
        })
        self.items.insertContentsOf(items, at: 0)
    }
}

class ViewController: UITableViewController {
    
    var tableViewManager: TableViewManager!
    var pickerControl: PickerControl?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 100;
        self.tableView.estimatedSectionFooterHeight = 100;


        tableViewManager = TableViewManager(tableView: self.tableView, sections: [FirstSection(vc: self), SecondSection(vc: self)])
        
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

