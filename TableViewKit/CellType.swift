//
//  CellType.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public enum CellType {

    case Nib(UINib, UITableViewCell.Type)
    case Class(UITableViewCell.Type)

    public var reusableIdentifier: String {
        switch self {
        case .Class(let cellClass):
            return String(cellClass)
        case .Nib(_, let cellClass):
            return String(cellClass)
        }
    }

    public var cellClass: UITableViewCell.Type {
        switch self {
        case .Class(let cellClass):
            return cellClass
        case .Nib(_, let cellClass):
            return cellClass
        }
    }
}
