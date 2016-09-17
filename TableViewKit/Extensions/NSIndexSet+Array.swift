import Foundation

extension IndexSet {

    init(_ array: [Int]) {
        let mutable = NSMutableIndexSet()
        array.forEach {mutable.add($0)}
        self.init(mutable)
    }
}
