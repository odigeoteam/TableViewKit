//
//  Diff.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 10/09/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

struct Diff {
    public var inserts: [Int]
    public var deletes: [Int]
    public var moves: [(Int, Int)]
}

class DiffIterator : IteratorProtocol {
    struct Coordinates {
        var x: Int
        var y: Int
    }
    var last: Coordinates
    private let matrix: [[Int]]
    
    init(matrix: [[Int]]){
        self.matrix = matrix
        self.last = Coordinates(x: matrix.count-1, y: matrix.first!.count-1)
    }
    
    func next() -> ArrayChanges? {
        while(last.x > 0 || last.y > 0) {
            if last.x == 0 {
                last.y -= 1
                return .inserts([last.y])
            } else if last.y == 0 {
                last.x -= 1
                return .deletes([last.x])
            } else if matrix[last.x][last.y] == matrix[last.x][last.y - 1] {
                last.y -= 1
                return .inserts([last.y])
            } else if matrix[last.x][last.y] == matrix[last.x - 1][last.y] {
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
    private let matrix: [[Int]]
    
    init(matrix: [[Int]]){
        self.matrix = matrix
    }
    
    func makeIterator() -> DiffIterator {
        return DiffIterator(matrix: matrix)
    }
}

extension Array {
    
    static func diff(between x: [Element], and y: [Element], where predicate: Predicate) -> Diff {
        var x = x
        let moves = y.enumerated().flatMap { (toIndex, element) -> (Int, Int)? in
            guard let fromIndex = x.index(where: { predicate($0, element) }),
                fromIndex != toIndex else { return nil }
            
            x.remove(at: fromIndex)
            x.insert(element, at: (toIndex >= x.count) ? x.count : toIndex)
            
            return (fromIndex, toIndex)
        }
        
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: y.count+1), count: x.count+1)
        for (i, xElem) in x.enumerated() {
            for (j, yElem) in y.enumerated() {
                if predicate(xElem, yElem) {
                    matrix[i+1][j+1] = matrix[i][j] + 1
                } else {
                    matrix[i+1][j+1] = Swift.max(matrix[i][j+1], matrix[i+1][j])
                }
            }
        }
        
        let changes = [ArrayChanges](DiffSequence(matrix: matrix))
        let inserts: [Int] = changes.flatMap { change -> [Int] in
            guard case .inserts(let array) = change else { return [] }
            return array
            }.sorted { $0 > $1 }

        
        let deletes: [Int] = changes.flatMap { change -> [Int] in
            guard case .deletes(let array) = change else { return [] }
            return array
            }.sorted { $0 < $1 }

        
        return Diff(inserts: inserts, deletes: deletes, moves: moves)
    }
}
