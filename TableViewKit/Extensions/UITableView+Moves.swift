import Foundation
import UIKit

extension UITableView {

    func moveRows(at indexPaths: [IndexPath], to newIndexPaths: [IndexPath]) {
        indexPaths.indices.forEach { index in
            moveRow(at: indexPaths[index], to: newIndexPaths[index])
        }
    }

    func moveSections(from: [Int], to: [Int]) {
        from.indices.forEach { index in
            moveSection(from[index], toSection: to[index])
        }
    }
}
