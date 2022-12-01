@testable import TableViewKit

final class TableViewManagerMock: TableViewManager {
    
    private(set) var zPositionForCellCallsCount = 0
    private(set) var zPositionForCellReceivedIndexPath: IndexPath?
    private(set) var zPositionForHeaderCallsCount = 0
    private(set) var zPositionForHeaderReceivedSection: Int?
    private(set) var zPositionForFooterCallsCount = 0
    private(set) var zPositionForFooterReceivedSection: Int?
    var zPositionForCellReturnValue: CGFloat?
    var zPositionForHeaderReturnValue: CGFloat?
    var zPositionForFooterReturnValue: CGFloat?
    
    override func zPositionForCell(at indexPath: IndexPath) -> CGFloat? {
        zPositionForCellCallsCount += 1
        zPositionForCellReceivedIndexPath = indexPath
        return zPositionForCellReturnValue
    }

    override func zPositionForHeader(in section: Int) -> CGFloat? {
        zPositionForHeaderCallsCount += 1
        zPositionForHeaderReceivedSection = section
        return zPositionForHeaderReturnValue
    }

    override func zPositionForFooter(in section: Int) -> CGFloat? {
        zPositionForFooterCallsCount += 1
        zPositionForFooterReceivedSection = section
        return zPositionForFooterReturnValue
    }

}
