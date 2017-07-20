import Foundation
@testable import TableViewKit

extension ArrayChanges: Equatable {
    public static func == (lhs: ArrayChanges<Element>, rhs: ArrayChanges<Element>) -> Bool {
        switch (lhs, rhs) {
        case (let .inserts(indexesLhs, elementsLhs),
              let .inserts(indexesRhs, elementsRhs)),
             (let .deletes(indexesLhs, elementsLhs),
              let .deletes(indexesRhs, elementsRhs)):
            if let elementsLhs = elementsLhs as? [Int],
                let elementsRhs = elementsRhs as? [Int] {
                return indexesLhs == indexesRhs && elementsLhs == elementsRhs
            } else {
                return false
            }
        case (let .updates(indexesLhs),
              let .updates(indexesRhs)):
            return indexesLhs == indexesRhs
        case (let .moves(indexesLhs),
              let .moves(indexesRhs)):
            guard indexesLhs.count == indexesRhs.count else {
                return false
            }
            return zip(indexesLhs, indexesRhs).reduce(true, { (carry, arg) -> Bool in
                let ((fromLhs, toLhs), (fromRhs, toRhs)) = arg
                return carry && (fromLhs == fromRhs && toLhs == toRhs)
            })
        case (.beginUpdates, .beginUpdates),
             (.endUpdates, .endUpdates):
            return true
        default:
            return false
        }
    }
}
