//
//  HeaderFooterDrawer.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation
import UIKit

public protocol HeaderFooterDrawer {
    
    static var cellType: HeaderFooterType { get }
    static func view(inManager manager: TableViewManager, withItem item: HeaderFooter) -> UITableViewHeaderFooterView
    static func draw(cell cell: UITableViewHeaderFooterView, withItem item: Any)
    
}

public extension HeaderFooterDrawer {
    static func view(inManager manager: TableViewManager, withItem item: HeaderFooter) -> UITableViewHeaderFooterView {
        return manager.tableView.dequeueReusableHeaderFooterViewWithIdentifier(self.cellType.reusableIdentifier)!
    }
}