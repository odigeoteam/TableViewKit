import Foundation

public struct ValidationError {
    public let rule: Any
    public let identifier: Any?
    public let error: NSError

    public init(rule: Any, identifier: Any?, error: NSError?) {
        self.rule = rule
        self.identifier = identifier
        self.error = error ?? NSError(domain: "Validator", code: -1, userInfo: nil)
    }
}
