import Foundation

/// A section that supports states.
///
/// A stateful section keep the `currentState`
/// and has a default implementation for `transition(to:)`
/// needed to perform a transition from the `currentState` to a `newState`.
/// You must implement `items(for:)`, that will be used to know
/// which items belong to which `State`.
public protocol Stateful: TableSection {

    /// A type that represent a state, such as an enum.
    associatedtype State

    /// The current state
    var currentState: State { get set }

    /// Returns the `items` belonging to a `state`
    ///
    /// - parameter state: A concrete `state`
    ///
    /// - returns: The `items` belonging to a `state`
    func items(for state: State) -> [TableItem]

    /// Performs a transition from the `currentState` to a `newState`
    ///
    /// - parameter newState: The `newState`
    func transition(to newState: State)
}

public extension Stateful {
    func transition(to newState: State) {
        items.replace(with: items(for: newState))
        currentState = newState
    }
}

public protocol StaticStateful: Stateful where State: Hashable {

    var states: [State: [TableItem]] { get }
}

public extension StaticStateful {

    func items(for state: State) -> [TableItem] {
        return states[state]!
    }

}
