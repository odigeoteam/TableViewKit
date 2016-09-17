import Foundation

public enum Height {
    case dynamic(CGFloat)
    case `static`(CGFloat)
    
    
    internal func estimated() -> CGFloat {
        switch self {
        case .static(_):
            return 0.0
        case .dynamic(let value):
            return value
        }
    }
    
    internal func height() -> CGFloat {
        switch self {
        case .static(let value):
            return value
        case .dynamic(_):
            return UITableViewAutomaticDimension
        }
    }
}
