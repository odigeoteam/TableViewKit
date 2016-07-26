//
//  TableViewDrawerCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 29/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewDrawerCellProtocol: class {
    
    func cellClass() -> TableViewCell.Type
    func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> TableViewCell
    func draw(cell cell: TableViewCell, withItem item: TableViewItemProtocol)
}

public class TableViewDrawerCell: TableViewDrawerCellProtocol {
    
    public init() {}
    
    public func cellClass() -> TableViewCell.Type {
        return TableViewCell.self
    }
    
    public func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> TableViewCell {
        
        let cellIdentifier = String(cellClass())
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TableViewCell
        if cell == nil {
            cell = cellClass().init(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        return cell!
    }
    
    public func draw(cell cell: TableViewCell, withItem item: TableViewItemProtocol) {
        
        cell.item = item
        cell.configure()
    }
}