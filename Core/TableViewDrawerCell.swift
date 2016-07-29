//
//  TableViewDrawerCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 29/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewDrawerCellProtocol {
    
    static var cell: TableViewCellType { get }
    func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> TableViewCell
    func draw(cell cell: TableViewCell, withItem item: TableViewItemProtocol)
}

public extension TableViewDrawerCellProtocol {
    func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> TableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(self.dynamicType.cell.reusableIdentifier) as! TableViewCell
    }
}


public struct TableViewDrawerCell: TableViewDrawerCellProtocol {
    
    public static var cell = TableViewCellType.Class(TableViewCell.self)
    
    public func draw(cell cell: TableViewCell, withItem item: TableViewItemProtocol) {
        
        cell.accessoryType = item.accessoryType
        cell.accessoryView = item.accessoryView
        
        cell.imageView?.image = item.image
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
    }
}
