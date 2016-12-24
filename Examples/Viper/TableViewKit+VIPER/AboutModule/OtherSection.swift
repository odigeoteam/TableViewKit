//
//  OtherSection.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 14/12/2016.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import TableViewKit

class OtherSection: Section {
    
    var items: ObservableArray<Item> = []
    
    init() {
        let item1 = MoreAboutItem(type: .contact, presenter: nil, manager: nil)
        items.append(item1)
    }
}
