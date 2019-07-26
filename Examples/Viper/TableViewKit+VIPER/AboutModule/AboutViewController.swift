import Foundation
import UIKit
import TableViewKit

class AboutViewController: UITableViewController, AboutViewControllerProtocol {

    var presenter: AboutPresenterProtocol?
    var tableViewManager: TableViewManager?

    private var insertSectionButtonItem: UIBarButtonItem?
    private var moveSectionButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Info"

        insertSectionButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(insertSection))
        moveSectionButtonItem = UIBarButtonItem(title: "Move", style: .plain, target: self, action: #selector(moveSection))

        let helpSection = HelpCenterSection(presenter: presenter)
        let moreAboutSection = MoreAboutSection(presenter: presenter, manager: tableViewManager)

        tableViewManager = TableViewManager(tableView: self.tableView)
        tableViewManager?.sections.replace(with: [helpSection, moreAboutSection])

        navigationItem.rightBarButtonItem = insertSectionButtonItem
    }

    func presentMessage(_ message: String, title: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    @objc func insertSection() {

        let newSection = OtherSection()
        tableViewManager?.sections.insert(newSection, at: 1)

        navigationItem.rightBarButtonItem = moveSectionButtonItem
    }

    @objc func moveSection() {

        guard let section1 = tableViewManager?.sections[0],
            let section2 = tableViewManager?.sections[1],
            let section3 = tableViewManager?.sections[2] else { return }

        tableViewManager?.sections.replace(with: [section2, section3, section1])

        navigationItem.rightBarButtonItem = nil
    }
}
