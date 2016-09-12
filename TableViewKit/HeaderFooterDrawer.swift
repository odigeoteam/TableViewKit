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

    static var type: HeaderFooterType { get }
    static func view(in manager: TableViewManager, with item: HeaderFooter) -> UITableViewHeaderFooterView
    static func draw(_ view: UITableViewHeaderFooterView, with item: Any)

}

public extension HeaderFooterDrawer {
    static func view(in manager: TableViewManager, with item: HeaderFooter) -> UITableViewHeaderFooterView {
        return manager.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.type.reusableIdentifier)!
    }
}
