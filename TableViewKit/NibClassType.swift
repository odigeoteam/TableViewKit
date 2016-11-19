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
