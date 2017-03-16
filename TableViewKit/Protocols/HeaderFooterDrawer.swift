import Foundation
import UIKit

/// The type of a header/footer (nib, class)
public typealias HeaderFooterType<View: UITableViewHeaderFooterView> = NibClassType<View>


/// A type that can draw either a header or a footer
public protocol HeaderFooterDrawer {
    associatedtype View: UITableViewHeaderFooterView
    associatedtype GenericItem

    /// Define the `type` of the header/footer
    static var type: HeaderFooterType<View> { get }
    
    /// Draw the `view` using the `item`
    ///
    /// - parameter view: The header/footer `view` that must be drawn
    /// - parameter item: The header/footer `item` that generated the drawer
    static func draw(_ view: View, with item: GenericItem)
    
    
    /// Returns the header/footer view from the `manager`
    ///
    /// - parameter manager: The `manager` where the header/footer came from
    /// - parameter item:    The header/footer `item`
    ///
    /// - returns: The header/footer view
    static func view(in manager: TableViewManager, with item: GenericItem) -> View
}

public extension HeaderFooterDrawer {
    
    /// Returns a dequeued header/footer
    static func view(in manager: TableViewManager, with item: GenericItem) -> View {
        return manager.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.type.reusableIdentifier) as! View
    }
}

/// A type-erased wrapper over any header or footer drawer
public struct AnyHeaderFooterDrawer {
    let type: HeaderFooterType<UITableViewHeaderFooterView>
    let view: (TableViewManager, HeaderFooter) -> UITableViewHeaderFooterView
    let draw: (UITableViewHeaderFooterView, HeaderFooter) -> ()

	/// Creates a type-erased drawer that wraps the given header or footer drawer
    public init<Drawer: HeaderFooterDrawer, GenericItem, View: UITableViewHeaderFooterView>(_ drawer: Drawer.Type) where Drawer.GenericItem == GenericItem, Drawer.View == View {
        self.type = drawer.type.headerFooterType
        self.view = { manager, item in drawer.view(in: manager, with: item as! GenericItem) }
        self.draw = { cell, item in drawer.draw(cell as! View, with: item as! GenericItem) }
    }
    
    func view(in manager: TableViewManager, with item: HeaderFooter) -> UITableViewHeaderFooterView {
        return view(manager, item)
    }
    
    func draw(_ view: UITableViewHeaderFooterView, with item: HeaderFooter) {
        draw(view, item)
    }
    
}
