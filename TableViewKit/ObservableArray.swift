import Foundation

enum ArrayChanges<Element> {
    case inserts([Int], [Element])
    case deletes([Int], [Element])
    case updates([Int])
    case moves([(Int, Int)])
    case beginUpdates
    case endUpdates
}
/// An observable array. It will notify any kind of changes.
public struct ObservableArray<T>: ExpressibleByArrayLiteral, Collection, MutableCollection, RangeReplaceableCollection {

    /// The type of the elements of an array literal.
    public typealias Element = T

    private var diff: Diff<T>!

    private var array: [T] {
        willSet {
            diff = Array.diff(between: array, and: newValue, where: compare)
        }
        didSet {
            callback?(.beginUpdates)
            if !diff.moves.isEmpty { callback?(.moves(diff.moves)) }
            if !diff.deletes.isEmpty { callback?(.deletes(diff.deletes, diff.deletesElement)) }
            if !diff.inserts.isEmpty { callback?(.inserts(diff.inserts, diff.insertsElement)) }
            callback?(.endUpdates)
            diff = nil
        }
    }

    var callback: ((ArrayChanges<T>) -> Void)?

    /// Creates an empty `ObservableArray`
    public init() {
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
    public init(arrayLiteral elements: Element...) {
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

    /// Replaces the specified subrange of elements with the given collection.
    ///
    /// - parameter subrange: The subrange that must be replaced
    /// - parameter newElements: The new elements that must be replaced
    // swiftlint:disable:next line_length
    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, C.Iterator.Element == T {
        array.replaceSubrange(subrange, with: newElements)
    }

    /// Replace its content with a new array
    ///
    /// - parameter array: The new array
    public mutating func replace(with array: [T]) {
        self.array = array
    }

    private func compare(lhs: T, rhs: T) -> Bool {
        if let lhs = lhs as? AnyEquatable {
            return lhs.equals(rhs)
        }
        return false
    }

}
