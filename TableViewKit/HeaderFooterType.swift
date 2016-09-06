//
//  HeaderFooterType.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public enum HeaderFooterType {

    case Nib(UINib, UITableViewHeaderFooterView.Type)
    case Class(UITableViewHeaderFooterView.Type)

    public var reusableIdentifier: String {
        switch self {
        case .Class(let cellClass):
            return String(cellClass)
        case .Nib(_, let cellClass):
            return String(cellClass)
        }
    }

    public var cellClass: UITableViewHeaderFooterView.Type {
        switch self {
        case .Class(let cellClass):
            return cellClass
        case .Nib(_, let cellClass):
            return cellClass
        }
    }
}
