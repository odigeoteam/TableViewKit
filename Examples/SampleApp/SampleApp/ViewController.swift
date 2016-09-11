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
        let textFieldItem = TextFieldItem(placeHolder: "Name", actionBarDelegate: vc)
        textFieldItem.validation.add(rule: ExistRule())
        let textFieldItem2 = TextFieldItem(placeHolder: "Surname", actionBarDelegate: vc)
        textFieldItem2.validation.add(rule: ExistRule())
        
        item.onSelection = { item in
            item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
            self.vc.showPickerControl()
        }
        dateItem.accessoryType = .disclosureIndicator
        dateItem.onSelection = { item in
            item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
            self.vc.showDatePickerControl()
        }
        selectionItem.accessoryType = .disclosureIndicator
        selectionItem.onSelection = { item in
            item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
            self.vc.showPickerControl()
        }
        
        states.insert([item, dateItem, selectionItem, textFieldItem, textFieldItem2], at: State.preParty.rawValue)
        states.insert([item2, selectionItem, dateItem, item3, textFieldItem2, textFieldItem], at: State.onParty.rawValue)
        states.insert([item2], at: State.afterParty.rawValue)
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
                let item = TextFieldItem(placeHolder: "Textfield \(index)", actionBarDelegate: vc)
                return item
            } else {
                let item = CustomItem(title: "Label  \(index)")
                item.onSelection = { item in
                    item.deselectRow(inManager: self.vc.tableViewManager, animated: true)
                }
                return item
            }
        })
        self.items.insert(contentsOf: items, at: 0)
    }
}

class ViewController: UITableViewController, ActionBarDelegate {
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .plain, target: self, action: #selector(validationAction))
    }
    
    
    fileprivate func showPickerControl() {
        
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
    
    fileprivate func showDatePickerControl() {
        
        let toDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let pickerDateControl = PickerControl(datePickerMode: .date, fromDate: Date(), toDate: toDate, minuteInterval: 0, selectCallback: { pickerControl, date in
            
            pickerControl.dismissPickerView()
            print(date)
            
            self.pickerControl = nil
            
            }, cancelCallback: nil)
        pickerDateControl.presentPickerOnView(view)
        
        pickerControl = pickerDateControl
    }
    
    @objc fileprivate func validationAction() {
        firstSection.swap(to: firstSection.currentState == .preParty ? .onParty : .afterParty)
        guard let error = tableViewManager.errors.first else { return }
        print(error)
        
    }
    
    fileprivate func indexPathForResponder(forDirection direction: Direction) -> IndexPath? {
        
        func isFirstResponder(item: Item) -> Bool {
            if isResponder(item: item),
                let indexPath = item.indexPath(inManager: tableViewManager),
                tableViewManager.tableView.cellForRow(at: indexPath)?.isFirstResponder == true {
                return true
            }
            return false
        }
        
        func isResponder(item: Item) -> Bool {
            if let responder = item as? UIResponder,
                responder.canBecomeFirstResponder {
                return true
            }
            return false
        }
        
        let array = tableViewManager.sections.flatMap { $0.items }
        
        guard let currentItem = array.first(where: isFirstResponder),
            let index = array.indexOf(currentItem)
            else { return nil }

        let item: Item?
        
        switch direction {
        case .next:
            item = array.suffix(from: index).dropFirst().first(where: isResponder)
        case .previous:
            item = array.prefix(upTo: index).reversed().first(where: isResponder)
        }
        
        return item?.indexPath(inManager: tableViewManager)
        
    }
    
    public func actionBar(_ actionBar: ActionBar, direction: Direction) -> IndexPath? {
        guard let indexPath = indexPathForResponder(forDirection: direction) else { return nil }
        
        tableViewManager.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableViewManager.tableView.cellForRow(at: indexPath)?.becomeFirstResponder()
        return indexPath
    }
    
    public func actionBar(_ actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) { }

}


