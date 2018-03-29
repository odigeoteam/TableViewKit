import Foundation
@testable import TableViewKit

extension ArrayChanges: Equatable {
    public static func == (lhs: ArrayChanges<Element>, rhs: ArrayChanges<Element>) -> Bool {
        guard
            let lhs = lhs as? ArrayChanges<Int>,
            let rhs = rhs as? ArrayChanges<Int> else { return false }
        switch (lhs, rhs) {
        case (let .inserts(indexesLhs, elementsLhs),
              let .inserts(indexesRhs, elementsRhs)),
             (let .deletes(indexesLhs, elementsLhs),
              let .deletes(indexesRhs, elementsRhs)):
            return indexesLhs == indexesRhs && elementsLhs == elementsRhs
        case (let .updates(indexesLhs),
              let .updates(indexesRhs)):
            return indexesLhs == indexesRhs
        case (let .moves(indexesLhs),
              let .moves(indexesRhs)):
            return indexesLhs.elementsEqual(indexesRhs, by: { $0.0 == $1.0 && $0.1 == $1.1 })
        case (let .beginUpdates(fromElementsLhs, toElementsLhs),
              let .beginUpdates(fromElementsRhs, toElementsRhs)),
             (let .endUpdates(fromElementsLhs, toElementsLhs),
              let .endUpdates(fromElementsRhs, toElementsRhs)):
            return fromElementsLhs == fromElementsRhs && toElementsLhs == toElementsRhs
        default:
            return false
        }
    }
}
