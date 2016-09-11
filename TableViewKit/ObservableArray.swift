//
//  ObservableArray.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 09/09/2016.
//
//

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
    
    private var _array: [T] {
        willSet {
            callback?(.beginUpdates)
        }
        didSet {
            let newArray =   _array as [AnyObject]
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
        self._array = []
    }
    
    public init(array: [T]) {
        self._array = array
    }
    
    public init(arrayLiteral elements: Element...) {
        self._array = elements
    }
    
    public func makeIterator() -> Array<T>.Iterator {
        return _array.makeIterator()
    }
    
    public var startIndex: Int {
        return _array.startIndex
    }
    
    public var endIndex: Int {
        return _array.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return _array.index(after: i)
    }
    
    public var isEmpty: Bool {
        return _array.isEmpty
    }
    
    public var count: Int {
        return _array.count
    }
    
    public subscript(index: Int) -> T {
        get {
            return _array[index]
        }
        set {
            _array[index] = newValue
        }
    }
    
    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, C.Iterator.Element == T {
        _array.replaceSubrange(subrange, with: newElements)
    }
    
    public mutating func replace(with array: [T]) {
        _array = array
    }
}
