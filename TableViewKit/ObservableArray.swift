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

public struct ObservableArray<T>: ArrayLiteralConvertible, CollectionType, MutableCollectionType, RangeReplaceableCollectionType {
    
    public typealias Element = T
    
    private var _array: [T] {
        willSet {
            callback?(.beginUpdates)
        }
        didSet {
            let newArray = _array
            var oldArray = oldValue
            _arraySet(oldArray, newArray: newArray)
            callback?(.endUpdates)
        }
    }
    
    private func _arraySet(oldArray: [T], newArray: [T]) {
        var oldArray = oldArray
        let moves = newArray.enumerate().flatMap { (toIndex, element) -> (Int, Int)? in
            let anyElement = element as! AnyObject
            guard let fromIndex = oldArray.indexOf({ $0 as! AnyObject === anyElement }) where
                fromIndex != toIndex else { return nil }
            
            oldArray.removeAtIndex(fromIndex)
            if (toIndex >= oldArray.count) {
                oldArray.append(element)
            } else {
                oldArray.insert(element, atIndex: toIndex)
            }
            return (fromIndex, toIndex)
        }
        
        let equals: Predicate = { lhs, rhs in
            let lhs = lhs as! AnyObject
            let rhs = rhs as! AnyObject
            return lhs === rhs
        }
        let diff = Array.diff(between: oldArray, and: newArray, where: equals)
        let deletes = diff.deletes
        let inserts = diff.inserts
        
        callback?(.moves(moves))
        callback?(.deletes(deletes))
        callback?(.inserts(inserts))
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
    
    public func generate() -> Array<T>.Generator {
        return _array.generate()
    }
    
    public var startIndex: Int {
        return _array.startIndex
    }
    
    public var endIndex: Int {
        return _array.endIndex
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

    public mutating func replaceRange<C where C : CollectionType, C.Generator.Element == T>(_ subrange: Range<Int>, with newElements: C) {
        _array.replaceRange(subrange, with: newElements)
    }
    
    public mutating func replace(with array: [T]) {
        _array = array
    }
}
