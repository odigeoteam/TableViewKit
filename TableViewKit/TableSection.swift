import Foundation
import UIKit

@available(*, deprecated, renamed: "TableSection")
public typealias Section = TableSection

/// A type that represent a section to be displayed
/// containing `items`, a `header` and a `footer`
public protocol TableSection: class, AnyEquatable {

    /// A array containing the `items` of the section
    var items: ObservableArray<TableItem> { get set }

    /// The `header` of the section, none if not defined
    /// - Default: none
    var header: HeaderFooterView { get }
    /// The `footer` of the section, none if not defined
    var footer: HeaderFooterView { get }

    var index: Int? { get }
}

public extension TableSection where Self: Equatable {

    func equals(_ other: Any?) -> Bool {
        if let other = other as? Self {
            return other == self
        }
        return false
}
}

extension TableSection {

    /// Empty header
    public var header: HeaderFooterView { return nil }
    /// Empty footer
    public var footer: HeaderFooterView { return nil }
}

// swiftlint:disable:next identifier_name
private var SectionTableViewManagerKey: UInt8 = 0

extension TableSection {

    public internal(set) var manager: TableViewManager? {
        get {
            return objc_getAssociatedObject(self, &SectionTableViewManagerKey) as? TableViewManager
        }
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &SectionTableViewManagerKey,
                                     newValue as AnyObject,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension TableSection {

    public func equals(_ other: Any?) -> Bool {
        if let other = other as AnyObject? {
            return other === self
        }
        return false
    }

    /// Returns the `index` of the `section`
    ///
    /// - returns: The `index` of the `section` or `nil` if not present
    public var index: Int? {
        return manager?.sections.index(of: self)
    }

    /// Register the section in the specified manager
    ///
    /// - parameter manager: A manager where the section may have been added
    internal func register(in manager: TableViewManager) {
        setup(in: manager)

        if case .view(let header) = header {
            manager.register(type(of: header).drawer.type)
        }
        if case .view(let footer) = footer {
            manager.register(type(of: footer).drawer.type)
        }
        items.forEach { item in
            item.manager = manager
            manager.register(type(of: item).drawer.type)
        }
    }

    /// Unregister the section
    internal func unregister() {
        self.manager = nil
        items.forEach { $0.manager = nil }
    }

    /// Setup the section internals
    ///
    /// - parameter manager: A manager where the section may have been added
    private func setup(in manager: TableViewManager) {
        self.manager = manager

        items.callback = { [weak self] changes in
            if let manager = self?.manager, let sectionIndex = self?.index {
                manager.onItemsUpdate(with: changes, forSectionIndex: sectionIndex)
            }
        }
    }

}

public extension Collection where Self.Iterator.Element == TableSection {
    /// Return the index of the `element` inside a collection of sections
    func index(of element: TableSection) -> Self.Index? {
        return index(where: { $0 === element })
    }
}
