import UIKit

open class TableViewKitDelegate: NSObject, UITableViewDelegate {

    open unowned var manager: TableViewManager
    open weak var scrollDelegate: UIScrollViewDelegate?
    private var sections: ObservableArray<Section> { return manager.sections }

    public required init(manager: TableViewManager) {
        self.manager = manager
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentItem = manager.item(at: indexPath) as? Selectable else { return }
        currentItem.didSelect()
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(at: indexPath) ?? tableView.rowHeight
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height(for: { $0.header }, inSection: section) ?? tableView.sectionHeaderHeight
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return height(for: { $0.footer }, inSection: section) ?? tableView.sectionFooterHeight
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeight(at: indexPath) ?? tableView.estimatedRowHeight
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeight(for: { $0.header }, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeight(for: { $0.footer }, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view(for: { $0.header }, inSection: section)
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view(for: { $0.footer }, inSection: section)
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let item = manager.item(at: indexPath) as? Editable else { return nil }
        return item.actions
    }

    /// Implementation of UITableViewDelegate
    open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return manager.item(at: indexPath) is ActionPerformable
    }

    /// Implementation of UITableViewDelegate
    // swiftlint:disable:next line_length
    open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard let item = manager.item(at: indexPath) as? ActionPerformable,
            let action = ItemAction(action: action) else { return false }
        return item.canPerformAction(action)
    }

    /// Implementation of UITableViewDelegate
    // swiftlint:disable:next line_length
    open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        guard let item = manager.item(at: indexPath) as? ActionPerformable,
            let action = ItemAction(action: action)  else { return }
        item.performAction(action)
    }

    /// Implementation of UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }

    /// Implementation of UIScrollViewDelegate
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    /// Implementation of UIScrollViewDelegate
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    fileprivate func view(for key: (Section) -> HeaderFooterView, inSection section: Int) -> UIView? {
        guard case .view(let item) = key(sections[section]) else { return nil }

        let drawer = type(of: item).drawer
        let view = drawer.view(in: manager, with: item)
        drawer.draw(view, with: item)

        return view
    }

    fileprivate func estimatedHeight(for key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        let item = key(sections[section])
        switch item {
        case .view(let view):
            guard let height = view.height else { return nil }
            return height.estimated
        case .title:
            return 1.0
        default:
            return nil
        }
    }

    fileprivate func estimatedHeight(at indexPath: IndexPath) -> CGFloat? {
        guard let height = manager.item(at: indexPath).height else { return nil }
        return height.estimated
    }

    fileprivate func height(for key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        guard case .view(let view) = key(sections[section]), let value = view.height
            else { return nil }
        return value.height
    }

    fileprivate func height(at indexPath: IndexPath) -> CGFloat? {
        guard let value = manager.item(at: indexPath).height else { return nil }
        return value.height
    }

}
