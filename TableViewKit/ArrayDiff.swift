import Foundation

struct Diff {
    var inserts: [Int]
    var deletes: [Int]
    var moves: [(Int, Int)]
    
    var isEmpty: Bool {
        return (inserts.count + deletes.count + moves.count) == 0
    }
    
    init(inserts: [Int] = [], deletes: [Int] = [], moves: [(Int, Int)] = []) {
        self.inserts = inserts
        self.deletes = deletes
        self.moves = moves
    }
    
    
}

class DiffIterator : IteratorProtocol {
    struct Coordinates {
        var x: Int
        var y: Int
    }
    var last: Coordinates
    private let matrix: Matrix<Int>
    
    init(matrix: Matrix<Int>){
        self.matrix = matrix
        self.last = Coordinates(x: matrix.rows-1, y: matrix.columns-1)
    }
    
    func next() -> ArrayChanges? {
        while(last.x > 0 || last.y > 0) {
            if last.x == 0 {
                last.y -= 1
                return .inserts([last.y])
            } else if last.y == 0 {
                last.x -= 1
                return .deletes([last.x])
            } else if matrix[last.x, last.y] == matrix[last.x, last.y - 1] {
                last.y -= 1
                return .inserts([last.y])
            } else if matrix[last.x, last.y] == matrix[last.x - 1, last.y] {
                last.x -= 1
                return .deletes([last.x])
            } else {
                last.x -= 1
                last.y -= 1
            }
        }
        return nil
    }
}

class DiffSequence : Sequence {
    private let matrix: Matrix<Int>
    
    init(matrix: Matrix<Int>){
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

    static func diff(between x: [Element], and y: [Element], where predicate: Predicate) -> Diff {
        
        var matrix = Matrix(rows: x.count+1, columns: y.count+1, repeatedValue: 0)
        for (i, xElem) in x.enumerated() {
            for (j, yElem) in y.enumerated() {
                if predicate(xElem, yElem) {
                    matrix[i+1, j+1] = matrix[i, j] + 1
                } else {
                    matrix[i+1, j+1] = Swift.max(matrix[i, j+1], matrix[i+1, j])
                }
            }
        }
        
        let changes = [ArrayChanges](DiffSequence(matrix: matrix))
        var inserts: [Int] = changes.flatMap { change -> [Int] in
            guard case .inserts(let array) = change else { return [] }
            return array
            }.sorted { $0 > $1 }

        
        var deletes: [Int] = changes.flatMap { change -> [Int] in
            guard case .deletes(let array) = change else { return [] }
            return array
            }.sorted { $0 < $1 }

        var moves: [(Int, Int)] = []

        var deleted: Int = 0
        for (deleteIndex, deleteAtIndex) in deletes.enumerated() {
            let elem = x[deleteAtIndex]
            let temp = inserts.index { predicate(y[$0], elem) }
            guard let insertIndex = temp else { continue }
            
            let insertAtIndex = inserts[insertIndex]
            deletes.remove(at: deleteIndex - deleted)
            inserts.remove(at: insertIndex)
            let movement = (deleteAtIndex, insertAtIndex)
            moves.append(movement)
            deleted += 1
        }

        
        return Diff(inserts: inserts, deletes: deletes, moves: moves)
    }

}
