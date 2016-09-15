//
//  MoreAboutCell.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 13/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import TableViewKit

class MoreAboutDrawer: CellDrawer {
    
    static open var type = CellType.class(UITableViewCell.self)
    
    static open func draw(_ cell: UITableViewCell, with item: Any) {
        
        let item = item as! MoreAboutItem
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.title
    }
}
