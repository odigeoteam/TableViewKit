//
//  TestObservableArray.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 14/12/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import XCTest
import TableViewKit

class ObservableArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInsert() {
        
        var numbers: ObservableArray<Int> = ObservableArray<Int>()
        numbers.replace(with: [4, 2, 1])
        numbers[0] = 3
        
        XCTAssert(numbers[0] == 3)
    }
}
