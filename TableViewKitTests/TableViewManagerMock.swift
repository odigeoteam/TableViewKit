@testable import TableViewKit

final class TableViewManagerMock: TableViewManager {
    
    private(set) var zPositionForCellCallsCount = 0
    private(set) var zPositionForCellReceivedIndexPath: IndexPath?
    var zPositionForCellReturnValue: CGFloat?
    
    override func zPositionForCell(at indexPath: IndexPath) -> CGFloat? {
        zPositionForCellCallsCount += 1
        zPositionForCellReceivedIndexPath = indexPath
        return zPositionForCellReturnValue
    }
}
