import Foundation

/// A type for a header or a footer that rapresent, if its' present,
/// if it's a simple `title` or if it's a custom `view`
///
/// - title: A simple `title`
/// - view:  A custom `view`
/// - none:  A empty header/footer
public enum HeaderFooterView: ExpressibleByNilLiteral {
    case title(String)
    case view(HeaderFooter)
    case none
    
    public init(nilLiteral: ()) {
        self = .none
    }
}

/// A type that it's associated to header/footer drawer
public protocol HeaderFooter: class {
    var drawer: HeaderFooterDrawer.Type { get }
    var height: Height? { get }
}
