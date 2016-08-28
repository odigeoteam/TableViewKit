//
//  UITableView+Register.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 28/08/16.
//
//

import UIKit

public extension UITableView {
    public func register(type type: CellType, bundle: NSBundle? = nil) {
        switch type {
        case .Class(let cellClass):
            registerClass(type.cellClass, forCellReuseIdentifier: type.reusableIdentifier)
        case .Nib(let nib, let cellClass):
            registerNib(nib, forCellReuseIdentifier: type.reusableIdentifier)
        }
    }
}
