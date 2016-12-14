import Foundation
import UIKit

extension UITableView {
    
    func moveRows(at indexPaths: [IndexPath], to newIndexPaths: [IndexPath]) {
        for (index, _) in indexPaths.enumerated() {
            moveRow(at: indexPaths[index], to: newIndexPaths[index])
        }
    }
    
    func moveSections(from: [Int], to: [Int]) {
        for (index, _) in from.enumerated() {
            moveSection(from[index], toSection: to[index])
        }
    }
}
