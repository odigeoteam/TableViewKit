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
        let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        numbers.replace(with: array, shouldPerformDiff: false)
        results = []
    }

    func testRemoveFirst() {
        reset()
        numbers.removeFirst()
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([0], [0]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults

        reset()
        numbers.removeFirst(3)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([0, 1, 2], [0, 1, 2]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testRemoveLast() {
        reset()
        numbers.removeLast()
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([9], [9]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults

        reset()
        numbers.removeLast(3)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([7, 8, 9], [7, 8, 9]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testRemoveAt() {
        reset()
        numbers.remove(at: 5)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([5], [5]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testRemoveSubrage() {
        reset()
        numbers.removeSubrange(1..<5)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([1, 2, 3, 4], [1, 2, 3, 4]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testRemoveAll() {
        reset()
        numbers.removeAll()
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .deletes([0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                                 [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testAppend() {
        reset()
        numbers.append(10)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .inserts([10], [10]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testAppendContentsOf() {
        reset()
        numbers.append(contentsOf: [10, 11])
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .inserts([10, 11], [10, 11]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testInsertAt() {
        reset()
        numbers.insert(-1, at: 0)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .inserts([0], [-1]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults

        reset()
        numbers.insert(-1, at: 5)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .inserts([5], [-1]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testInsertContentsOf() {
        reset()
        numbers.insert(contentsOf: [-1, -2], at: 0)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .inserts([0, 1], [-1, -2]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults

        reset()
        numbers.insert(contentsOf: [-1, -2], at: 5)
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .inserts([5, 6], [-1, -2]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testMove() {
        reset()
        numbers.replace(with: [0, 1, 2, 4, 5, 6, 7, 3, 8, 9])
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .moves([(3, 7)]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }

    func testReplaces() {
        reset()
        numbers.replace(with: [11, 0, 7, 2, 1, 3, 12, 13, 4, 6, 14, 8, 9])
        expectedResults = [
            .beginUpdates(from: [], to: []),
            .moves([(1, 4), (7, 2)]),
            .deletes([5], [5]),
            .inserts([10, 7, 6, 0], [14, 13, 12, 11]),
            .endUpdates(from: [], to: [])]
        expect(self.results) == expectedResults
    }
}
