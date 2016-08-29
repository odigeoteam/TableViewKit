//
//  SelectionViewController.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 28/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
import TableViewKit

public protocol SelectionItemProtocol: ItemProtocol {
    
    var value: Any { get }
    var selected: Bool { get set }
    
    init(title: String, value: Any, selected: Bool)
}

public enum SelectionType {
    case Single, Multiple
}

public class SelectionItem: SelectionItemProtocol {    
    public var title: String?
    
    public var value: Any
    public var selected: Bool
    
    public var onSelection: (ItemProtocol) -> () = { _ in }
    
    public var accessoryType: UITableViewCellAccessoryType = .None
    public var accessoryView: UIView?
    public var cellHeight: CGFloat? = UITableViewAutomaticDimension
    
    public var drawer: CellDrawer.Type = CustomDrawer.self

    
    public required init(title: String, value: Any, selected: Bool = false) {
        self.value = value
        self.selected = selected
        self.title = title
    }
}

public class SelectionViewController: UITableViewController {
    
    private var tableViewManager: TableViewManager!
    private var selectionType: SelectionType!
    private var selectedItems: [SelectionItem]!
    
    public var items: [SelectionItem]!
    public var onSelection: (([SelectionItem]) -> ())?
    
    private func commonInit() {
        
        selectionType = .Single
        items = []
        selectedItems = []
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public init(style: UITableViewStyle, selectionType: SelectionType) {
        
        super.init(style: style)
        commonInit()
        self.selectionType = selectionType
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewManager = TableViewManager(tableView: self.tableView)
        setupTaleViewItems()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        onSelection?(selectedItems)
    }
    
    private func fillSelected() {
        
        selectedItems = items.filter { $0.selected == true }
    }
    
    private func setupTaleViewItems() {
        
        let section = Section()
        tableViewManager.sections.append(section)
        
        for element in items {
            
            element.onSelection = { item in
                self.toogleItemCheck(item as! SelectionItem)
            }
            element.accessoryType = element.selected ? .Checkmark : .None
            section.items.append(element)
        }
        
        fillSelected()
    }
    
    private func toogleItemCheck(item: SelectionItem) {
        
        if selectionType == .Single {
            
            if let checkedItem = itemSelected() {
                checkedItem.selected = false
                checkedItem.accessoryType = .None
                checkedItem.reloadRow(inManager: tableViewManager, withAnimation: .Fade)
            }
        }
        
        item.selected = !item.selected
        item.accessoryType = item.accessoryType == .Checkmark ? .None : .Checkmark
        item.reloadRow(inManager: tableViewManager, withAnimation: .Fade)
        
        fillSelected()
    }
    
    private func itemSelected() -> SelectionItem? {
        
//        for section in tableViewManager.sections {
//            let checkedItems = section.items.filter { $0.accessoryType == .Checkmark }
//            if checkedItems.count != 0 {
//                return checkedItems.first as? SelectionItemProtocol
//            }
//        }
        return nil
    }
}
