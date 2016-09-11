//
//  TableViewCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 08/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

open class BaseCell: UITableViewCell {
    weak open var tableViewManager: TableViewManager!
    open var item: Item?
}
