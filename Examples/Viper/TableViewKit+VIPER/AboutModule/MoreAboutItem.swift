//
//  MoreAboutItem.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 06/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import TableViewKit

enum MoreAboutItemType {
    
    case faq, contact, terms, feedback, share, rate
    
    func title() -> String {
        switch self {
        case .faq:
            return "FAQ"
        case .contact:
            return "Contact Us"
        case .terms:
            return "Terms and Conditions"
        case .feedback:
            return "Send us your feedback"
        case .share:
            return "Share the app"
        case .rate:
            return "Rate the app"
        }
    }
}

class MoreAboutItem: Item, Selectable {
    
    var type: MoreAboutItemType
    var title: String?
    
    var drawer: CellDrawer.Type = MoreAboutDrawer.self
    var onSelection: (Selectable) -> () = { _ in }

    init(type: MoreAboutItemType) {
        
        self.type = type
        self.title = type.title()
    }
}
