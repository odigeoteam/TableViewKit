//
//  HeaderFooterType.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public enum HeaderFooterType {

    case nib(UINib, UITableViewHeaderFooterView.Type)
    case `class`(UITableViewHeaderFooterView.Type)

    public var reusableIdentifier: String {
        switch self {
        case .class(let cellClass):
            return String(describing: cellClass)
        case .nib(_, let cellClass):
            return String(describing: cellClass)
        }
    }

    public var cellClass: UITableViewHeaderFooterView.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        }
    }
}
