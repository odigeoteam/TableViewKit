import UIKit

open class TableViewKitDataSource: NSObject, UITableViewDataSource {

    open unowned var manager: TableViewManager
    private var sections: ObservableArray<Section> { return manager.sections }

    public required init(manager: TableViewManager) {
        self.manager = manager
    }

    /// Implementation of UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    /// Implementation of UITableViewDataSource
    open func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        return section.items.count
    }

    /// Implementation of UITableViewDataSource
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = manager.item(at: indexPath)
        let drawer = type(of: currentItem).drawer

        let cell = drawer.cell(in: manager, with: currentItem, for: indexPath)
        drawer.draw(cell, with: currentItem)

        return cell
    }

    /// Implementation of UITableViewDataSource
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title(for: { $0.header }, inSection: section)
    }

    /// Implementation of UITableViewDataSource
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return title(for: { $0.footer }, inSection: section)
    }

    /// Implementation of UITableViewDataSource
    // swiftlint:disable:next line_length
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Intentionally blank. Required to use UITableViewRowActions
    }

    /// Implementation of UITableViewDataSource
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return manager.item(at: indexPath) is Editable
    }

    fileprivate func title(for key: (Section) -> HeaderFooterView, inSection section: Int) -> String? {
        if case .title(let value) = key(sections[section]) {
            return value
        }
        return nil
    }

}
