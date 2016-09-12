//
//  HelpCenterItem.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 06/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import TableViewKit

class HelpCenterItem: Item {
    
    var drawer: CellDrawer.Type = HelpCenterDrawer.self
    var height: ImmutableMutableHeight? = .mutable(44.0)
    
    var title: String?
    var subtitles: [String]?
    var onHelpCenterButtonSelected: (() -> ())?
    
    init() {
        title = "Find the answer to your questions"
        subtitles = ["Check my booking status", "Change my flight", "Check my baggage allowance"]
    }
}
