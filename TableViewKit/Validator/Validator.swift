//
//  Validator.swift
//  ios-whitelabel
//
//  Created by Alfredo Delli Bovi on 07/07/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation

public protocol ContentValidatable {
    associatedtype Input
    var validationContent: Input { get }
}

public protocol Validationable {
    var validation: Validation<String?> { get set }
}

public protocol Validatable {
    associatedtype Input

    var error: NSError? { get }
    func test(validationContent: Input) -> Bool
}


public protocol Regexable {
    var regex: String { get }
}

public extension Regexable where Self: Validatable {
    func test(validationContent: String?) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(validationContent)
    }
}

public struct ValidatorManager<Input> {
    public var errors: [ValidationError] {
        get {
            return validations.reduce([], combine: { $0 + $1.errors })
        }
    }

    private var validations: [Validation<Input>] = []

    public mutating func add<R: Validatable where R.Input == Input>(getInput: () -> Input, withRule rule: R) {
        validations.append(Validation.init(forInput: getInput, rule: rule))
    }

    public mutating func add(validation validation: Validation<Input>) {
        guard (!validations.contains { $0 === validation }) else { return }
        validations.append(validation)
    }

    public init() { }
}
