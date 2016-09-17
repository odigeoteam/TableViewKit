import Foundation

typealias Predicate = (Any, Any) -> Bool

enum ArrayChanges {
    case inserts([Int])
    case deletes([Int])
    case updates([Int])
    case moves([(Int, Int)])
    case beginUpdates
    case endUpdates
}

public struct ObservableArray<T>: ExpressibleByArrayLiteral, Collection, MutableCollection, RangeReplaceableCollection {
    
    public typealias Element = T
    
    private var array: [T] {
        willSet {
            callback?(.beginUpdates)
        }
        didSet {
            let newArray =   array as [AnyObject]
            let oldArray = oldValue as [AnyObject]

            let diff = Array.diff(between: oldArray, and: newArray, where: { lhs, rhs in
                let lhs = lhs as AnyObject
                let rhs = rhs as AnyObject
                return lhs === rhs
            })
            
            callback?(.moves(diff.moves))
            callback?(.deletes(diff.deletes))
            callback?(.inserts(diff.inserts))
            callback?(.endUpdates)
        }
    }
    
    var callback: ((ArrayChanges) -> ())?
    
    public init() {
        self.array = []
    }
    
    public init(array: [T]) {
        self.array = array
    }
    
    public init(arrayLiteral elements: Element...) {
        self.array = elements
    }
    
    public func makeIterator() -> Array<T>.Iterator {
        return array.makeIterator()
    }
    
    public var startIndex: Int {
        return array.startIndex
    }
    
    public var endIndex: Int {
        return array.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public subscript(index: Int) -> T {
        get {
            return array[index]
        }
        set {
            array[index] = newValue
        }
    }
    
    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, C.Iterator.Element == T {
        array.replaceSubrange(subrange, with: newElements)
    }
    
    public mutating func replace(with array: [T]) {
        self.array = array
    }
}
