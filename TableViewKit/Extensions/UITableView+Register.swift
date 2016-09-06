//
//  UITableView+Register.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 28/08/16.
//
//

import UIKit

public extension UITableView {
    public func register(type: CellType, bundle: Bundle? = nil) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forCellReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forCellReuseIdentifier: type.reusableIdentifier)
        }
    }

    public func register(type: HeaderFooterType, bundle: Bundle? = nil) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        }
    }
}
