//
//  CellType.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public enum CellType {
    
    case nib(UINib, UITableViewCell.Type)
    case `class`(UITableViewCell.Type)
    
    public var reusableIdentifier: String {
        switch self {
        case .class(let cellClass):
            return String(describing: cellClass)
        case .nib(_, let cellClass):
            return String(describing: cellClass)
        }
    }
    
    public var cellClass: UITableViewCell.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        }
    }
}
