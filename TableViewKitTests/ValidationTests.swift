//
//  ValidationTests.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 30/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import XCTest
import ODGTableViewKit
import Nimble

class ValidationTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testPresenceValidatorOK() {
        
        let presenceValidator = ODGPresenceValidator()
        let error = presenceValidator.validate("String", name: "Field Name", parameters: nil)
        
        expect(error).to(beNil())
    }
    
    func testPresenceValidatorKO() {
        
        let presenceValidator = ODGPresenceValidator()
        let error = presenceValidator.validate("", name: "Field Name", parameters: nil)
        
        expect(error).notTo(beNil())
    }
    
    func testEmailValidatorOK() {
        
        let emailValidator = ODGEmailValidator()
        let error = emailValidator.validate("good@email.com", name: "Email Field", parameters: nil)
        
        expect(error).to(beNil())
    }
    
    func testEmailValidatorKO() {
        
        let emailValidator = ODGEmailValidator()
        let error = emailValidator.validate("bad@email", name: "Email Field", parameters: nil)
        
        expect(error).notTo(beNil())
    }
}