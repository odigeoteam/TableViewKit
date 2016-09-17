import Foundation

/// A Nib/Class loadable type
public enum NibClassType<T> {
    
    /// If it must be loaded from a UINib
    case nib(UINib, T.Type)
    /// If it must be loaded from a Class
    case `class`(T.Type)
    
    /// The reusable identifier for the header/footer
    public var reusableIdentifier: String {
        return String(describing: cellClass)
    }
    
    /// The header/footer class
    public var cellClass: T.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        }
    }
}
