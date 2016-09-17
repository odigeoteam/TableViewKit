import Foundation
import TableViewKit

class HelpCenterSection: Section {
    
    var items: ObservableArray<Item> = []
    var header: HeaderFooterView = .title("How can we help you today?")
    let presenter: AboutPresenterProtocol?
    
    required init(presenter: AboutPresenterProtocol?) {
        
        self.presenter = presenter
        
        let helpCenterItem = HelpCenterItem()
        helpCenterItem.onHelpCenterButtonSelected = {
            self.presenter?.showHelpCenter()
        }
        
        items.append(helpCenterItem)
    }
}
