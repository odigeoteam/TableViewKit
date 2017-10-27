import Foundation

enum ArrayChanges<Element> {
    case inserts([Int], [Element])
    case deletes([Int], [Element])
    case updates([Int])
    case moves([(Int, Int)])
    case beginUpdates(from: [Element], to: [Element])
    case endUpdates(from: [Element], to: [Element])
}

/// An observable array. It will notify any kind of changes.
public class ObservableArray<T>: RandomAccessCollection, ExpressibleByArrayLiteral {

    /// The type of the elements of an array literal.
    public typealias Element = T

    var array: [T]

    var callback: ((ArrayChanges<T>) -> Void)?

    /// Creates an empty `ObservableArray`
    public required init() {
        self.array = []
    }

    /// Creates an `ObservableArray` with the contents of `array`
    ///
    /// - parameter array: The initial content
    public init(array: [T]) {
        self.array = array
    }

    /// Creates an instance initialized with the given elements.
    ///
    /// - parameter elements: An array of elements
    public required init(arrayLiteral elements: Element...) {
        self.array = elements
    }

    /// Returns an iterator over the elements of the collection.
    public func makeIterator() -> Array<T>.Iterator {
        return array.makeIterator()
    }

    /// The position of the first element in a nonempty collection.
    public var startIndex: Int {
        return array.startIndex
    }

    /// The position of the last element in a nonempty collection.
    public var endIndex: Int {
        return array.endIndex
    }

    /// Returns the position immediately after the given index.
    ///
    /// - parameter i: A valid index of the collection. i must be less than endIndex.
    ///
    /// - returns:  The index value immediately after i.
    public func index(after index: Int) -> Int {
        return array.index(after: index)
    }

    /// A Boolean value indicating whether the collection is empty.
    public var isEmpty: Bool {
        return array.isEmpty
    }

    /// The number of elements in the collection.
    public var count: Int {
        return array.count
    }

    /// Accesses the element at the specified position.
    ///
    /// - parameter index:
    public subscript(index: Int) -> T {
        get {
            return array[index]
        }
        set {
            array[index] = newValue
        }
    }

    /// Replace its content with a new array
    ///
    /// - parameter array: The new array
    public func replace(with array: [T], shouldPerformDiff: Bool = true) {
        guard shouldPerformDiff else {
            self.array = array
            return
        }

        let diff = Array.diff(between: self.array,
                              and: array,
                              subrange: 0..<self.array.count,
                              where: compare)
        self.array = array
        notifyChanges(with: diff)
    }

    /// Replaces the specified subrange of elements with the given collection.
    ///
    /// - parameter subrange: The subrange that must be replaced
    /// - parameter newElements: The new elements that must be replaced
    // swiftlint:disable:next line_length
    public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Iterator.Element == T {
        let temp = Array(newElements)
        var diff = Array.diff(between: self.array,
                              and: temp,
                              subrange: subrange,
                              where: compare)
        self.array.replaceSubrange(subrange, with: newElements)
        diff.toElements = self.array
        notifyChanges(with: diff)
    }

    /// Append `newElement` to the array.
    public func append(contentsOf newElements: [T]) {
        insert(contentsOf: newElements, at: array.count)
    }

    /// Append `newElement` to the array.
    public func append(_ newElement: T) {
        replaceSubrange(array.count..<array.count, with: [newElement])
    }

    /// Insert `newElement` at index `i`.
    public func insert(_ newElement: T, at index: Int) {
        replaceSubrange(index..<index, with: [newElement])
    }

    /// Insert elements `newElements` at index `i`.
    public func insert(contentsOf newElements: [T], at index: Int) {
        replaceSubrange(index..<index, with: newElements)
    }

    /// Remove and return the element at index i.
    @discardableResult
    public func remove(at index: Int) -> T {
        let element = array[index]
        replaceSubrange(index..<index + 1, with: [])
        return element
    }

    /// Removes the specified number of elements from the beginning of the collection.
    public func removeFirst(_ n: Int) {
        replaceSubrange(0..<n, with: [])
    }

    /// Remove an element from the end of the array in O(1).
    @discardableResult
    public func removeFirst() -> T {
        let element = array[0]
        replaceSubrange(0..<1, with: [])
        return element
    }

    /// Removes the specified number of elements from the end of the collection.
    public func removeLast(_ n: Int) {
        replaceSubrange((array.count - n)..<array.count, with: [])
    }

    /// Remove an element from the end of the array in O(1).
    @discardableResult
    public func removeLast() -> T {
        let element = array[array.count - 1]
        replaceSubrange(array.count - 1..<array.count, with: [])
        return element
    }

    /// Remove all elements from the array.
    public func removeAll() {
        replaceSubrange(0..<array.count, with: [])
    }

    private func compare(lhs: T, rhs: T) -> Bool {
        if let lhs = lhs as? AnyEquatable {
            return lhs.equals(rhs)
        }
        return false
    }

    private func notifyChanges(with diff: Diff<T>) {
        callback?(.beginUpdates(from: diff.fromElements, to: diff.toElements))
        if !diff.moves.isEmpty { callback?(.moves(diff.moves)) }
        if !diff.deletes.isEmpty { callback?(.deletes(diff.deletes, diff.deletesElement)) }
        if !diff.inserts.isEmpty { callback?(.inserts(diff.inserts, diff.insertsElement)) }
        callback?(.endUpdates(from: diff.fromElements, to: diff.toElements))
    }

}
