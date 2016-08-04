//
//  TableViewDrawerCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 29/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol CellDrawer {
    
    var cellType: CellType { get }
    func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> BaseCell
    func draw(cell cell: BaseCell, withItem item: BaseItem)
}

public extension CellDrawer {
    
    func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> BaseCell {
        return tableView.dequeueReusableCellWithIdentifier(self.cellType.reusableIdentifier) as! BaseCell
    }
}


public struct BaseDrawer: CellDrawer {
    
    public var cellType = CellType.Class(BaseCell.self)
    
    public func draw(cell cell: BaseCell, withItem item: BaseItem) {
        
        cell.accessoryType = item.accessoryType
        cell.accessoryView = item.accessoryView
        cell.textLabel?.text = item.title
    }
}
