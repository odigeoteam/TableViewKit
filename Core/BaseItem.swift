//
//  TableViewItem.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol ItemProtocol: class {
    
    /// Section
    weak var section: Section! { get set }
    var indexPath: NSIndexPath? { get }

    /// Drawer used to draw cell. Strategy pattern
    var drawer: CellDrawer { get set }
    
    var title: String? { get set }
    
    var cellStyle: UITableViewCellStyle { get set }
    var accessoryType: UITableViewCellAccessoryType { get set }
    var accessoryView: UIView? { get set }
    var cellHeight: CGFloat? { get set }

    var selectionHandler: ((BaseItem) -> ())? { get set }

    func selectRowAnimated(animated: Bool)
    func selectRowAnimated(animated: Bool, scrollPosition: UITableViewScrollPosition)
    func deselectRowAnimated(animated: Bool)
    func reloadRowWithAnimation(animation: UITableViewRowAnimation)
    func deleteRowWithAnimation(animation: UITableViewRowAnimation)
}

public class BaseItem: ItemProtocol {
    
    public weak var section: Section!
    public var indexPath: NSIndexPath? {
        get {
            guard let sectionIndex = section?.index, let rowIndex = section?.items.indexOf(self) else { return nil }
            return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
        }
    }
    
    public var drawer: CellDrawer = BaseDrawer()
    
    // MARK: Cell values
    
    public var title: String?
    
    // MARK: Cell style
    
    public var cellStyle: UITableViewCellStyle = .Default
    public var accessoryType: UITableViewCellAccessoryType = .None
    public var accessoryView: UIView?
    public var cellHeight: CGFloat? = UITableViewAutomaticDimension
    
    // MARK: Handlers
    
    public var selectionHandler: ((BaseItem) -> ())?
    
    // MARK: Manipulating table view row
    
    public func selectRowAnimated(animated: Bool) {
        
        selectRowAnimated(animated, scrollPosition: .None)
    }
    
    public func selectRowAnimated(animated: Bool, scrollPosition: UITableViewScrollPosition) {
        
        section.tableViewManager.tableView.selectRowAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
    public func deselectRowAnimated(animated: Bool) {
        
        if let itemIndexPath = indexPath {
            section.tableViewManager.tableView.deselectRowAtIndexPath(itemIndexPath, animated: animated)
        }
    }
    
    public func reloadRowWithAnimation(animation: UITableViewRowAnimation) {
        
        if let itemIndexPath = indexPath {
            section.tableViewManager.tableView.reloadRowsAtIndexPaths([itemIndexPath], withRowAnimation: animation)
        }
    }
    
    public func deleteRowWithAnimation(animation: UITableViewRowAnimation) {
        
        if let itemIndexPath = indexPath {
            section.tableViewManager.tableView.deleteRowsAtIndexPaths([itemIndexPath], withRowAnimation: animation)
        }
    }
    
    // MARK: Constructor
    
    public init() { }
    
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}

extension BaseItem: Equatable {}
public func ==(lhs: BaseItem, rhs: BaseItem) -> Bool {
    return lhs === rhs
}

