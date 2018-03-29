import XCTest
@testable import TableViewKit
import Nimble

extension Int: AnyEquatable {
    public func equals(_ other: Any?) -> Bool {
        if let other = other as? Int {
            return self == other
        }
        return false
    }
}

class ObservableArrayTests: XCTestCase {
    var results: [ArrayChanges<Int>]!
    var numbers: ObservableArray<Int>!
    var expectedResults: [ArrayChanges<Int>]!
    let from = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    override func setUp() {
        super.setUp()
        results = []
        numbers = []
        numbers.callback = { changes in
            self.results.append(changes)
        }
    }

    override func tearDown() {
        super.tearDown()
        results = nil
        numbers = nil
    }

    func reset() {
        numbers.replace(with: from, shouldPerformDiff: false)
        results = []
    }

    func testRemoveFirst() {
        reset()
        numbers.removeFirst()
        var to = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([0], [0]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults

        reset()
        to = [3, 4, 5, 6, 7, 8, 9]
        numbers.removeFirst(3)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([0, 1, 2], [0, 1, 2]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testRemoveLast() {
        reset()
        numbers.removeLast()
        var to = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([9], [9]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults

        reset()
        numbers.removeLast(3)
        to = [0, 1, 2, 3, 4, 5, 6]
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([7, 8, 9], [7, 8, 9]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testRemoveAt() {
        let to = [0, 1, 2, 3, 4, 6, 7, 8, 9]
        reset()
        numbers.remove(at: 5)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([5], [5]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testRemoveAll() {
        let to = [Int]()
        reset()
        numbers.removeAll()
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testAppend() {
        let to = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        reset()
        numbers.append(10)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .inserts([10], [10]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testAppendContentsOf() {
        let to = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        reset()
        numbers.append(contentsOf: [10, 11])
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .inserts([11, 10], [11, 10]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testInsertAt() {
        var to = [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        reset()
        numbers.insert(-1, at: 0)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .inserts([0], [-1]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults

        reset()
        to = [0, 1, 2, 3, 4, -1, 5, 6, 7, 8, 9]
        numbers.insert(-1, at: 5)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .inserts([5], [-1]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testInsertContentsOf() {
        var to = [-1, -2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        reset()
        numbers.insert(contentsOf: [-1, -2], at: 0)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .inserts([1, 0], [-2, -1]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults

        reset()
        to = [0, 1, 2, 3, 4, -1, -2, 5, 6, 7, 8, 9]
        numbers.insert(contentsOf: [-1, -2], at: 5)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .inserts([6, 5], [-2, -1]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testMove() {
        let to = [0, 1, 2, 4, 5, 6, 7, 3, 8, 9]
        reset()
        numbers.replace(with: to)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .moves([(3, 7)]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testMoveFromBeginning() {
        let to = [9, 1, 2, 3, 4, 5, 6, 7, 8, 0]
        reset()
        numbers.replace(with: to)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .moves([(0, 9)]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testReplaces() {
        let to = [11, 0, 7, 2, 1, 3, 12, 13, 4, 6, 14, 8, 9]
        reset()
        numbers.replace(with: to)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .moves([(1, 4), (2, 7)]),
            .deletes([5], [5]),
            .inserts([10, 7, 6, 0], [14, 13, 12, 11]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testReplacesAllNew() {
        let to = [100, 101, 102, 103, 104, 105, 106, 107, 108, 109]
        reset()
        numbers.replace(with: to)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
            .inserts([9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [109, 108, 107, 106, 105, 104, 103, 102, 101, 100]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testReplacesAllSame() {
        let to = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        reset()
        numbers.replace(with: to)
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }

    func testReplaceSingleValue() {
        let to = [0, 1, 99, 3, 4, 5, 6, 7, 8, 9]
        reset()
        numbers[2] = 99
        expectedResults = [
            .beginUpdates(from: from, to: to),
            .deletes([2], [2]),
            .inserts([2], [99]),
            .endUpdates(from: from, to: to)]
        expect(self.results) == expectedResults
    }
}
