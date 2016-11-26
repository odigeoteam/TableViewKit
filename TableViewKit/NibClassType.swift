import Foundation

/// A Nib/Class loadable type
public enum NibClassType<T> {
    
    /// If it must be loaded from a UINib
    case nib(UINib, T.Type)
    /// If it must be loaded from a Class
    case `class`(T.Type)
    
    /// The reusable identifier for the type
    public var reusableIdentifier: String {
        return String(describing: typeClass)
    }
    
    /// The type class
    public var typeClass: T.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
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
        }
    }
}
