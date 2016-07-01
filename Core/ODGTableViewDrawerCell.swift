//
//  ODGTableViewDrawerCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 29/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol ODGTableViewDrawerCellProtocol: class {
    
    func cellClass() -> ODGTableViewCell.Type
    func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> ODGTableViewCell
    func draw(cell cell: ODGTableViewCell, withItem item: ODGTableViewItemProtocol)
}

public class ODGTableViewDrawerCell: ODGTableViewDrawerCellProtocol {
    
    public init() {}
    
    public func cellClass() -> ODGTableViewCell.Type {
        return ODGTableViewCell.self
    }
    
    public func cell(forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> ODGTableViewCell {
        
        let cellIdentifier = String(cellClass())
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ODGTableViewCell
        if cell == nil {
            cell = cellClass().init(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        return cell!
    }
    
    public func draw(cell cell: ODGTableViewCell, withItem item: ODGTableViewItemProtocol) {
        
        cell.item = item
        cell.configure()
    }
}