import Foundation
import UIKit

/// The type of a header/footer (nib, class)
public typealias HeaderFooterType = NibClassType<UITableViewHeaderFooterView>

/// A type that can draw either a header or a footer
public protocol HeaderFooterDrawer {
    
    /// Define the `type` of the header/footer
    static var type: HeaderFooterType { get }
    
    /// Draw the `view` using the `item`
    ///
    /// - parameter view: The header/footer `view` that must be drawn
    /// - parameter item: The header/footer `item` that generated the drawer
    static func draw(_ view: UITableViewHeaderFooterView, with item: Any)
    
    
    /// Returns the header/footer view from the `manager`
    ///
    /// - parameter manager: The `manager` where the header/footer came from
    /// - parameter item:    The header/footer `item`
    ///
    /// - returns: The header/footer view
    static func view(in manager: TableViewManager, with item: HeaderFooter) -> UITableViewHeaderFooterView
}

public extension HeaderFooterDrawer {
    
    /// Returns a dequeued header/footer
    static func view(in manager: TableViewManager, with item: HeaderFooter) -> UITableViewHeaderFooterView {
        return manager.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.type.reusableIdentifier)!
    }
}
