import Foundation

/// A type for a header or a footer that rapresent, if its' present,
/// if it's a simple `title` or if it's a custom `view`
public enum HeaderFooterView: ExpressibleByNilLiteral {

    /// A simple `title` string
    case title(String)
    /// A custom `view`
    case view(HeaderFooter)
    /// A empty header/footer
    case none

    public init(nilLiteral: ()) {
        self = .none
    }
}

/// A type that it's associated to header/footer drawer
public protocol HeaderFooter: class {

    /// The `drawer` of the header/footer
    static var drawer: AnyHeaderFooterDrawer { get }

    /// The `height` of the header/footer
    var height: Height? { get }
}
