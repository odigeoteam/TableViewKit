//
//  CustomItem.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 21/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import ODGTableViewKit

class CustomItem: ODGTableViewItem {

    override init() {
        
        super.init()
        
        drawer = CustomDrawer()
        cellHeight = 77
    }
}

class CustomDrawer: ODGTableViewDrawerCell {
    
    override func cellClass() -> ODGTableViewCell.Type {
        return CustomCell.self
    }
}