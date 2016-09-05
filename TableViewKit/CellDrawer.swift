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
    
    static var cellType: CellType { get }
    static func cell(inManager manager: TableViewManager, withItem item: Item, forIndexPath: IndexPath) -> BaseCell
    static func draw(_ cell: BaseCell, withItem item: Any)
    
}

public extension CellDrawer {
    static func cell(inManager manager: TableViewManager, withItem item: Item, forIndexPath indexPath: IndexPath) -> BaseCell {
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: self.cellType.reusableIdentifier, for: indexPath) as! BaseCell
        cell.tableViewManager = manager
        cell.item = item
        return cell
    }
}
