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
    static func cell(in manager: TableViewManager, with item: Item, for: IndexPath) -> UITableViewCell
    static func draw(_ cell: UITableViewCell, with item: Any)

}

public extension CellDrawer {
    
    static func cell(in manager: TableViewManager, with item: Item, for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: self.type.reusableIdentifier, for: indexPath)
        
        if let cell = cell as? ItemCompatible {
            cell.item = item
        }
        
        return cell
    }
}
