import Foundation

struct Diff<Element> {
    var inserts: [Int]
    var deletes: [Int]
    var moves: [(Int, Int)]

    var insertsElement: [Element]
    var deletesElement: [Element]
    var fromElements: [Element]
    var toElements: [Element]

    var isEmpty: Bool {
        return (inserts.count + deletes.count + moves.count) == 0
    }

    init(inserts: [Int] = [], deletes: [Int] = [], moves: [(Int, Int)] = [],
         insertsElement: [Element] = [], deletesElement: [Element] = [],
         fromElements: [Element] = [], toElements: [Element] = []) {
        self.inserts = inserts
        self.deletes = deletes
        self.moves = moves
        self.insertsElement = insertsElement
        self.deletesElement = deletesElement
        self.fromElements = fromElements
        self.toElements = toElements
    }
}

enum ArrayIndexesChanges {
    case inserts(Int)
    case deletes(Int)
    case updates(Int)
    case moves(Int, Int)
    case beginUpdates
    case endUpdates
}

struct Movement: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(from.hashValue ^ to.hashValue)
    }

    static func == (lhs: Movement, rhs: Movement) -> Bool {
        return (lhs.from == rhs.from && lhs.to == rhs.to)
    }

    let from: Int
    let to: Int
}

extension Array where Element == ArrayIndexesChanges {
    func filterInsertsIndexes(withOffset offset: Int) -> [Int] {
        return compactMap { change -> Int? in
            guard case .inserts(let index) = change else { return nil }
            return index + offset
        }
    }

    func filterDeletesIndexes(withOffset offset: Int) -> [Int] {
        return compactMap { change -> Int? in
            guard case .deletes(let index) = change else { return nil }
            return index + offset
        }
    }

    func filterMovesIndexes<Element>(insertsIndexes: inout [Int],
                                     deletesIndexes: inout [Int],
                                     between x: ArraySlice<Element>,
                                     and y: ArraySlice<Element>,
                                     where predicate: (Element, Element) -> Bool) -> [(Int, Int)] {
        var moves = Set<Movement>()
        let rangeX = (x.startIndex..<x.endIndex)
        let rangeY = (y.startIndex..<y.endIndex)

        var deleted: Int = 0
        for (deleteIndex, deleteAtIndex) in deletesIndexes.enumerated() {
            for (insertIndex, insertAtIndex) in insertsIndexes.enumerated() {
                if rangeX.contains(deleteAtIndex) &&
                    rangeY.contains(insertAtIndex) &&
                    predicate(x[deleteAtIndex], y[insertAtIndex]) {
                    deletesIndexes.remove(at: deleteIndex - deleted)
                    insertsIndexes.remove(at: insertIndex)
                    let movement: Movement
                    if deleteAtIndex < insertAtIndex {
                        movement = Movement(from: deleteAtIndex, to: insertAtIndex)
                    } else {
                        movement = Movement(from: insertAtIndex, to: deleteAtIndex)
                    }
                    moves.insert(movement)

                    deleted += 1
                    break
                }
            }
        }

        return moves.map { ($0.from, $0.to) }
    }
}

class DiffIterator: IteratorProtocol {
    struct Coordinates {
        var x: Int
        var y: Int
    }
    var last: Coordinates
    private let matrix: Matrix<Int>

    init(matrix: Matrix<Int>) {
        self.matrix = matrix
        self.last = Coordinates(x: matrix.rows - 1, y: matrix.columns - 1)
    }

    func next() -> ArrayIndexesChanges? {
        while last.x > 0 || last.y > 0 {
            if last.x == 0 {
                last.y -= 1
                return .inserts(last.y)
            } else if last.y == 0 {
                last.x -= 1
                return .deletes(last.x)
            } else if matrix[last.x, last.y] == matrix[last.x, last.y - 1] {
                last.y -= 1
                return .inserts(last.y)
            } else if matrix[last.x, last.y] == matrix[last.x - 1, last.y] {
                last.x -= 1
                return .deletes(last.x)
            } else {
                last.x -= 1
                last.y -= 1
            }
        }
        return nil
    }
}

class DiffSequence: Sequence {
    private let matrix: Matrix<Int>

    init(matrix: Matrix<Int>) {
        self.matrix = matrix
    }

    func makeIterator() -> DiffIterator {
        return DiffIterator(matrix: matrix)
    }
}

struct Matrix<Element> {

    let rows: Int
    let columns: Int
    var grid: [Element]

    init(rows: Int, columns: Int, repeatedValue: Element) {
        self.rows = rows
        self.columns = columns
        self.grid = [Element](repeating: repeatedValue, count: rows * columns)
    }

    subscript(row: Int, column: Int) -> Element {
        get {
            return grid[(row * columns) + column]
        }
        set {
            grid[(row * columns) + column] = newValue
        }
    }
}

extension Array {

    typealias Predicate = (Element, Element) -> Bool

    static func diff(between x: [Element], and y: [Element],
                     subrange: Range<Index>? = nil,
                     where predicate: Predicate) -> Diff<Element> {
        let sliceOfX: ArraySlice<Element>
        let sliceOfY: ArraySlice<Element>
        let offsetForY: Int
        if let subrange = subrange {
            sliceOfX = x[subrange]
            sliceOfY = y[y.startIndex..<y.endIndex]
            offsetForY = sliceOfX.startIndex
        } else if x.startIndex == y.startIndex && x.endIndex == y.endIndex {
            sliceOfX = makeOptimalSlice(between: x, and: y, where: predicate)
            sliceOfY = y[sliceOfX.startIndex..<sliceOfX.endIndex]
            offsetForY = 0
        } else {
            sliceOfX = x[x.startIndex..<x.endIndex]
            sliceOfY = y[y.startIndex..<y.endIndex]
            offsetForY = 0
        }

        let matrix = makeLCSMatrix(between: sliceOfX, and: sliceOfY, where: predicate)

        let changes = [ArrayIndexesChanges](DiffSequence(matrix: matrix))

        let lowerBound = sliceOfX.startIndex
        var inserts = changes
            .filterInsertsIndexes(withOffset: lowerBound)
            .sorted { $0 > $1 }

        var deletes = changes
            .filterDeletesIndexes(withOffset: lowerBound)
            .sorted { $0 < $1 }

        let moves = changes
            .filterMovesIndexes(insertsIndexes: &inserts,
                                deletesIndexes: &deletes,
                                between: sliceOfX,
                                and: sliceOfY,
                                where: predicate)

        let diff = Diff(inserts: inserts,
                        deletes: deletes,
                        moves: moves,
                        insertsElement: inserts.compactMap { y[$0 - offsetForY] },
                        deletesElement: deletes.compactMap { x[$0] },
                        fromElements: x,
                        toElements: y)

        return diff
    }

    static func makeOptimalSlice(between x: [Element],
                                 and y: [Element],
                                 where predicate: Predicate) -> ArraySlice<Element> {
        var startIndex = x.startIndex
        var endIndex = x.endIndex

        for (i, xElem) in x.lazy.enumerated() {
            guard i < y.count else { break }

            startIndex = i
            let yElem = y[i]
            if !predicate(xElem, yElem) {
                break
            }
        }

        for (i, xElem) in x.lazy.enumerated().reversed() {
            guard i < y.count, startIndex < endIndex else { break }

            endIndex = i + 1
            let yElem = y[i]
            if !predicate(xElem, yElem) {
                break
            }

        }

        return x[startIndex..<endIndex]
    }

    static func makeLCSMatrix(between x: ArraySlice<Element>,
                              and y: ArraySlice<Element>,
                              where predicate: Predicate) -> Matrix<Int> {
        var matrix = Matrix(rows: x.count + 1, columns: y.count + 1, repeatedValue: 0)
        for (i, xElem) in x.enumerated() {
            for (j, yElem) in y.enumerated() {
                if predicate(xElem, yElem) {
                    matrix[i + 1, j + 1] = matrix[i, j] + 1
                } else {
                    matrix[i + 1, j + 1] = Swift.max(matrix[i, j + 1], matrix[i + 1, j])
                }
            }
        }
        return matrix
    }

}
