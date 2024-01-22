import Foundation
import UIKit

/// A Nib/Class loadable type
public enum NibClassType<T> {

    /// If it must be loaded from a UINib
    case nib(UINib, T.Type)
    /// If it must be loaded from a Class
    case `class`(T.Type)
    /// If it must be loaded from a Storyboard prototype
    case prototype(String, T.Type)

    /// The reusable identifier for the type
    public var reusableIdentifier: String {
        switch self {
        case .class, .nib:
            return String(describing: typeClass)
        case .prototype(let identifier, _):
            return identifier
        }
    }

    /// The type class
    public var typeClass: T.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        case .prototype(_, let cellClass):
            return cellClass
        }
    }

}

extension NibClassType where T: UITableViewCell {
    var cellType: NibClassType<UITableViewCell> {
        switch self {
        case .class(let type):
            return NibClassType<UITableViewCell>.class(type)
        case .nib(let nib, let type):
            return NibClassType<UITableViewCell>.nib(nib, type)
        case .prototype(let identifier, let type):
            return NibClassType<UITableViewCell>.prototype(identifier, type)
        }
    }
}

extension NibClassType where T: UITableViewHeaderFooterView {
    var headerFooterType: NibClassType<UITableViewHeaderFooterView> {
        switch self {
        case .class(let type):
            return NibClassType<UITableViewHeaderFooterView>.class(type)
        case .nib(let nib, let type):
            return NibClassType<UITableViewHeaderFooterView>.nib(nib, type)
        case .prototype(let identifier, let type):
            return NibClassType<UITableViewHeaderFooterView>.prototype(identifier, type)
        }
    }
}
