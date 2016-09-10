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
    var items: ObservableArray<Item> = []
    var states: [[Item]] = []
    
    enum State: Int, RawRepresentable {
        case preParty
        case onParty
        case afterParty
    }
    
    var currentState: State = .preParty {
        didSet {
            items.replace(with: states[currentState.rawValue])
        }
    }

    let vc: ViewController
    
    internal var header: HeaderFooterView = .view(CustomHeaderItem(title: "First Section"))
    internal var footer: HeaderFooterView = .view(CustomHeaderItem(title: "Section Footer\nHola"))

    required init(vc: ViewController) {
        self.vc = vc
        
        let item = CustomItem(title: "Passengers")
        let item2 = CustomItem(title: "Testing")
        let item3 = CustomItem(title: "Testing 2")
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
        
        states.insert([item, dateItem, selectionItem, textFieldItem, textFieldItem2], atIndex: State.preParty.rawValue)
        states.insert([item2, selectionItem, dateItem, item3, textFieldItem2, textFieldItem], atIndex: State.onParty.rawValue)
        states.insert([item2], atIndex: State.afterParty.rawValue)
        swap(to: .preParty)
    }
    
    func swap(to newState: State) {
        currentState = newState
    }

}

class SecondSection: Section {
    var items: ObservableArray<Item> = []

    internal var header: HeaderFooterView = .view(CustomHeaderItem(title: "Second Section"))
    
    let vc: ViewController

    required init(vc: ViewController) {
        self.vc = vc
        
        let total: [Int] = Array(1...100)
        let items = total.map({ (index) -> Item in
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
    
    var firstSection: FirstSection!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 100;
        self.tableView.estimatedSectionFooterHeight = 100;


        firstSection = FirstSection(vc: self)
        tableViewManager = TableViewManager(tableView: self.tableView, sections: [firstSection, SecondSection(vc: self)])
        
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
        firstSection.swap(to: firstSection.currentState == .preParty ? .onParty : .afterParty)
        guard let error = tableViewManager.errors.first else { return }
        print(error)
        
    }
}


