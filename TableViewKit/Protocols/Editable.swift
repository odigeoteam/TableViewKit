//
//  Editable.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 31/10/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public typealias TableViewCellEditingStyleCompletion = () -> Void

public enum TableViewCellEditingStyle {
    
    case none
    case delete(String?, TableViewCellEditingStyleCompletion?)
    case insert(TableViewCellEditingStyleCompletion?)
    
    var completion: TableViewCellEditingStyleCompletion? {
        switch self {
        case .insert(let completion), .delete(_, let completion):
            return completion
        default:
            return nil
        }
    }
    
    func style() -> UITableViewCellEditingStyle {
        switch self {
        case .delete:
            return UITableViewCellEditingStyle.delete
        case .insert:
            return UITableViewCellEditingStyle.insert
        default:
            return UITableViewCellEditingStyle.none
        }
    }
    
    func title() -> String? {
        switch self {
        case .delete(let title, _):
            return title
        default:
            return nil
        }
    }
}

public protocol Editable {
    
    var editingStyle: TableViewCellEditingStyle { get }
    var rowActions: [UITableViewRowAction]? { get set }
}

public extension Editable {
    
    public var editingStyle: TableViewCellEditingStyle {
        get {
            return .none
        }
    }
}
