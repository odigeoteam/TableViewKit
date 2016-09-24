//
//  Stateful.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 23/09/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public protocol Stateful: Section {
    associatedtype State
    
    var currentState: State { get set }
    
    func items(for state: State) -> [Item]
    func transition(to newState: State)
}

public extension Stateful {
    func transition(to newState: State) {
        items.replace(with: items(for: newState))
        currentState = newState
    }
}

public protocol StaticStateful: Stateful {
    associatedtype State: Hashable
    
    var states: [State: [Item]] { get }
}

public extension StaticStateful {
    
    func items(for state: State) -> [Item] {
        return states[state]!
    }

}
