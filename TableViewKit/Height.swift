import Foundation

/// Defines either a dynamic or static height
public enum Height {

    /// A dynamic height, calculated with autolayout with an estimated value
    case dynamic(CGFloat)

    /// A static height
    case `static`(CGFloat)

    /// Returns the estimated value of the height
    internal var estimated: CGFloat {
        switch self {
        case .static(let value):
            return value
        case .dynamic(let value):
            return value
        }
    }

    /// Returns the height value
    internal var height: CGFloat {
        switch self {
        case .static(let value):
            return value
        case .dynamic(_):
            return UITableViewAutomaticDimension
        }
    }
}
