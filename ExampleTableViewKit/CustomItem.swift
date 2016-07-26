//
//  CustomItem.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 21/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import TableViewKit

class CustomItem: TableViewItem {

    override init() {
        
        super.init()
        
        drawer = CustomDrawer()
        cellHeight = 77
    }
}

class CustomDrawer: TableViewDrawerCell {
    
    override func cellClass() -> TableViewCell.Type {
        return CustomCell.self
    }
}