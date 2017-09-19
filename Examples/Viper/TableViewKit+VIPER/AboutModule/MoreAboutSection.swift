import Foundation
import TableViewKit

class MoreAboutSection: TableSection {

    var items: ObservableArray<TableItem> = []
    var header: HeaderFooterView = .title("More about eDreams")
    let presenter: AboutPresenterProtocol?
    weak var manager: TableViewManager?

    required init(presenter: AboutPresenterProtocol?, manager: TableViewManager?) {

        self.presenter = presenter
        self.manager = manager

        let moreAction = UITableViewRowAction(style: .normal, title: "More", handler: { _, _ in
            print("MoreAction executed")
        })
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { _, indexPath in
            self.items.remove(at: indexPath.row)
        })

        let types: [MoreAboutItemType] = [.faq, .contact, .terms, .feedback, .share, .rate]
        let items: [TableItem] = types.map {
            let moreAboutItem = MoreAboutItem(type: $0, presenter: presenter, manager: manager)
            moreAboutItem.actions = [deleteAction, moreAction]
            return moreAboutItem
        }

        self.items.replace(with: items)
    }
}
