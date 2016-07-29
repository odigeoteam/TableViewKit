//
//  Validation.swift
//  ios-whitelabel
//
//  Created by Alfredo Delli Bovi on 08/07/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation

struct AnyValidatable<Input>: Validatable {
    let testContainer: (Input) -> Bool
    let rule: Any
    let error: NSError?
    
    init<R: Validatable where R.Input == Input>(base: R) {
        self.testContainer = base.test
        self.rule = base
        self.error = base.error
    }
    
    func test(validationContent: Input) -> Bool {
        return self.testContainer(validationContent)
    }
    
}

public struct Validation<Input> {
    let forInput: () -> Input
    let identifier: Any?
    var rules: [AnyValidatable<Input>] = []
    
    var errors: [ValidationError] {
        get {
            let content = self.forInput()
            return rules.flatMap { ruleContainer -> ValidationError? in
                return !ruleContainer.test(content) ? ValidationError(rule: ruleContainer.rule, identifier: identifier, error: ruleContainer.error) : nil
            }
        }
    }
    
    public init(forInput: () -> Input, withIdentifier identifier: Any? = nil) {
        self.forInput = forInput
        self.identifier = identifier
    }
    
    public init<C: ContentValidatable where C.Input == Input>(forInput input: C, withIdentifier identifier: Any? = nil) {
        self.forInput = { input.validationContent }
        self.identifier = identifier
    }
    
    public init<R: Validatable where R.Input == Input>(forInput: () -> Input, withIdentifier identifier: Any? = nil, rule: R) {
        self.forInput = forInput
        self.identifier = identifier
        self.rules.append(AnyValidatable.init(base: rule))
    }
    
    public mutating func add<R: Validatable where R.Input == Input>(rule rule: R) {
        self.rules.append(AnyValidatable.init(base: rule))
    }
}