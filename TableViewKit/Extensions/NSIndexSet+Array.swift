import Foundation

extension IndexSet {

    /// Initialize an `IndexSet` with a array of integers.
    ///
    /// - parameter array: An array of integers
    init(_ array: [Int]) {
        let mutable = NSMutableIndexSet()
        array.forEach { mutable.add($0) }
        self.init(mutable)
    }
}
