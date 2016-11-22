import Foundation
import UIKit

/// An object that controls a `tableView`.
/// It controls how to display an array of sections, from the header, to its items, to the footer.
/// It automatically registers any related initial or new views/cells for reusability.
/// Any changes of the sections will be automatically animated and reflected.
open class TableViewManager: NSObject {
    
    /// The `tableView` linked to this manager
    open let tableView: UITableView
    
    /// An array of sections
    open var sections: ObservableArray<Section>
    
    open var animation: UITableViewRowAnimation = .automatic
    
    
    /// Initialize a `TableViewManager` with a `tableView`.
    ///
    /// - parameter tableView: A `tableView` that will be controlled by the `TableViewManager`
    public init(tableView: UITableView) {
        self.tableView = tableView
        self.sections = []
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupSections()
        
    }

    /// Initialize a `TableViewManager` with a `tableView` and an initial array of sections
    ///
    /// - parameter tableView: A `tableView` that will be controlled by the `TableViewManager`
    /// - parameter sections: An array of sections
    public init(tableView: UITableView, sections: [Section]) {
        self.tableView = tableView
        self.sections = ObservableArray(array: sections)
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupSections()
    }
    
    private func setupSections() {
        sections.forEach { section in
            section.setup(in: self)
            section.register(in: self)
        }
        sections.callback = { [weak self] in self?.onSectionsUpdate(withChanges: $0) }
    }
    
    private func onSectionsUpdate(withChanges changes: ArrayChanges){
        switch changes {
        case .inserts(let array):
            array.forEach { index in
                sections[index].setup(in: self)
                sections[index].register(in: self)
            }
            tableView.insertSections(IndexSet(array), with: animation)
        case .deletes(let array):
            tableView.deleteSections(IndexSet(array), with: animation)
        case .updates(let array):
            tableView.reloadSections(IndexSet(array), with: animation)
        case .moves(_): break
        case .beginUpdates:
            if (animation == .none) {
                UIView.setAnimationsEnabled(false)
            }
            tableView.beginUpdates()
        case .endUpdates:
            tableView.endUpdates()
            if (animation == .none) {
                UIView.setAnimationsEnabled(true)
            }
        }
    }
}

extension TableViewManager {
    
    fileprivate func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    fileprivate func view(for key: (Section) -> HeaderFooterView, inSection section: Int) -> UIView? {
        guard case .view(let item) = key(sections[section]) else { return nil }
        
        let drawer = item.drawer
        let view = drawer.view(in: self, with: item)
        drawer.draw(view, with: item)
        
        return view
    }
    
    fileprivate func title(for key: (Section) -> HeaderFooterView, inSection section: Int) -> String? {
        if case .title(let value) = key(sections[section]) {
            return value
        }
        return nil
        
    }
    
    fileprivate func estimatedHeight(for key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        let item = key(sections[section])
        switch item {
        case .view(let view):
            guard let height = view.height else { return nil }
            return height.estimated
        case .title(_):
            return 1.0
        default:
            return nil
        }
    }
    
    fileprivate func estimatedHeight(at indexPath: IndexPath) -> CGFloat? {
        guard let height = item(at: indexPath).height else { return nil }
        return height.estimated
    }
    

    
    fileprivate func height(for key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        guard case .view(let view) = key(sections[section]), let value = view.height
            else { return nil }
        return value.height
    }
    
    fileprivate func height(at indexPath: IndexPath) -> CGFloat? {
        guard let value = item(at: indexPath).height else { return nil }
        return value.height
    }
    
}

extension TableViewManager: UITableViewDataSource {
    
    /// Implementation of UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// Implementation of UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        return section.items.count
    }
    
    /// Implementation of UITableViewDataSource
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = item(at: indexPath)
        let drawer = currentItem.drawer
        
        let cell = drawer.cell(in: self, with: currentItem, for: indexPath)
        drawer.draw(cell, with: currentItem)
        
        return cell
    }
    
    /// Implementation of UITableViewDataSource
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title(for: {$0.header}, inSection: section)
    }
    
    /// Implementation of UITableViewDataSource
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return title(for: {$0.footer}, inSection: section)
    }
    
    /// Implementation of UITableViewDataSource
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Intentionally blank. Required to use UITableViewRowActions
    }
}

extension TableViewManager: UITableViewDelegate {
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentItem = item(at: indexPath) as? Selectable else { return }
        currentItem.didSelect()
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(at: indexPath) ?? tableView.rowHeight
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height(for: {$0.header}, inSection: section) ?? tableView.sectionHeaderHeight
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return height(for: {$0.footer}, inSection: section) ?? tableView.sectionFooterHeight
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeight(at: indexPath) ?? tableView.estimatedRowHeight
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeight(for: {$0.header}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeight(for: {$0.footer}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view(for: {$0.header}, inSection: section)
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view(for: {$0.footer}, inSection: section)
    }
    
    /// Implementation of UITableViewDelegate
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let item = item(at: indexPath) as? Editable else { return nil }
        return item.actions
    }
}
