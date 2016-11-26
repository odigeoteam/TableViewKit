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

public struct HeaderFooterDrawerOf {
    
    let _view: (TableViewManager, HeaderFooter) -> UITableViewHeaderFooterView
    let _draw: (UITableViewHeaderFooterView, HeaderFooter) -> ()
    
    public init<Drawer: HeaderFooterDrawer, GenericItem, View: UITableViewHeaderFooterView>(_ drawer: Drawer.Type) where Drawer.GenericItem == GenericItem, Drawer.View == View {
        switch drawer.type {
        case .class(let type):
            self.type = NibClassType<UITableViewHeaderFooterView>.class(type)
        case .nib(let nib, let type):
            self.type = NibClassType<UITableViewHeaderFooterView>.nib(nib, type)
        }
        self._view = { manager, item in drawer.view(in: manager, with: item as! GenericItem) }
        self._draw = { cell, item in drawer.draw(cell as! View, with: item as! GenericItem) }
    }
    
    public let type: HeaderFooterType<UITableViewHeaderFooterView>
    
    public func view(in manager: TableViewManager, with item: HeaderFooter) -> UITableViewHeaderFooterView {
        return _view(manager, item)
    }
    
    
    public func draw(_ view: UITableViewHeaderFooterView, with item: HeaderFooter) {
        _draw(view, item)
    }
    
}
