//
//  TableView+Moves.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 14/12/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func moveRows(at indexPaths: [IndexPath], to newIndexPaths: [IndexPath]) {
        for (index, _) in indexPaths.enumerated() {
            moveRow(at: indexPaths[index], to: newIndexPaths[index])
        }
    }
    
    func moveSections(from: [Int], to: [Int]) {
        for (index, _) in from.enumerated() {
            beginUpdates()
            moveSection(from[index], toSection: to[index])
            endUpdates()
        }
    }
}
