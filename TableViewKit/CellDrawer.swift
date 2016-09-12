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

    static var type: CellType { get }
    static func cell(in manager: TableViewManager, with item: Item, for: IndexPath) -> BaseCell
    static func draw(_ cell: BaseCell, with item: Any)

}

public extension CellDrawer {
    static func cell(in manager: TableViewManager, with item: Item, for indexPath: IndexPath) -> BaseCell {
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: self.type.reusableIdentifier, for: indexPath) as! BaseCell
        cell.manager = manager
        cell.item = item
        return cell
    }
}
