//
//  HelpCenterCell.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 06/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import TableViewKit

class HelpCenterDrawer: CellDrawer {
    
    static var cellType: CellType = CellType.nib(UINib(nibName: String(describing: HelpCenterCell.self), bundle: Bundle.main), HelpCenterCell.self)
    
    static func draw(_ cell: BaseCell, withItem item: Any) {
        
        guard let helpCenterCell = cell as? HelpCenterCell else { return }
        guard let helpCenterItem = item as? HelpCenterItem else { return }
        
        helpCenterCell.selectionStyle = .none
        helpCenterCell.titleLabel.text = helpCenterItem.title
    }
}

class HelpCenterCell: BaseCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var helpCenterButton: UIButton!
    
    @IBAction func helpCenterButtonSelected() {
        guard let helpCenterItem = item as? HelpCenterItem else { return }
        helpCenterItem.onHelpCenterButtonSelected?()
    }
}
