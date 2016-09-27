import Foundation

struct AnyValidatable<Input>: Validatable {
    let testContainer: (Input) -> Bool
    let rule: Any
    let error: NSError?

    init<R: Validatable>(base: R) where R.Input == Input {
        self.testContainer = base.test
        self.rule = base
        self.error = base.error
    }

    func test(_ validationContent: Input) -> Bool {
        return self.testContainer(validationContent)
    }

}

open class Validation<Input> {
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

    public init(forInput: @escaping () -> Input, withIdentifier identifier: Any? = nil) {
        self.forInput = forInput
        self.identifier = identifier
    }

    public init<C: ContentValidatable>(forInput input: C, withIdentifier identifier: Any? = nil) where C.Input == Input {
        self.forInput = { input.validationContent }
        self.identifier = identifier
    }

    public init<R: Validatable>(forInput: @escaping () -> Input, withIdentifier identifier: Any? = nil, rule: R) where R.Input == Input {
        self.forInput = forInput
        self.identifier = identifier
        self.rules.append(AnyValidatable.init(base: rule))
    }

    open func add<R: Validatable>(rule: R) where R.Input == Input {
        self.rules.append(AnyValidatable.init(base: rule))
    }
}
