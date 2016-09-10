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
            var oldArray = oldValue as [AnyObject]
            
            let moves = newArray.enumerated().flatMap { (toIndex, element) -> (Int, Int)? in
                guard
                    let fromIndex = oldArray.index(where: { $0 === element }),
                    fromIndex != toIndex else { return nil }
                
                oldArray.remove(at: fromIndex)
                if (toIndex >= oldArray.count) {
                    oldArray.append(element)
                } else {
                    oldArray.insert(element, at: toIndex)
                }
                return (fromIndex, toIndex)
            }
            
            let equals: Predicate = { lhs, rhs in
                let lhs = lhs as AnyObject
                let rhs = rhs as AnyObject
                return lhs === rhs
            }
            let diff = Array.diff(between: oldArray, and: newArray, where: equals)
            let deletes = diff.deletes
            let inserts = diff.inserts
            
            callback?(.moves(moves))
            callback?(.deletes(deletes))
            callback?(.inserts(inserts))
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
