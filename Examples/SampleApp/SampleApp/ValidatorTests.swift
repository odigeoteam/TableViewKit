import XCTest
import TableViewKit
import Nimble

extension String: ContentValidatable {

    public var validationContent: String? {
        get {
            return self
        }
    }
}

extension Int: ContentValidatable {

    public var validationContent: Int {
        get {
            return self
        }
    }
}

class ValidatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExistRule() {

        let value = "Test"

        let validation = Validation<String?>(forInput: value, withIdentifier: value)
        validation.add(rule: ExistRule())

        var validator = ValidatorManager<String?>()
        validator.add(validation: validation)

        expect(validator.errors.count) == 0
    }

    func testCharactersLengthRule() {

        let value = "Odigeo"

        let validation = Validation<String?>(forInput: value, withIdentifier: value)
        validation.add(rule: CharactersLengthRule(min: 3, max: 6))

        var validator = ValidatorManager<String?>()
        validator.add(validation: validation)

        expect(validator.errors.count) == 0
    }

    func testNumberBetweenRule() {

        let value: Int = 9

        let validation = Validation<Int>(forInput: value, withIdentifier: value)
        validation.add(rule: NumberBetweenRule(min: 5, max: 10))

        var validator = ValidatorManager<Int>()
        validator.add(validation: validation)

        expect(validator.errors.count) == 0
    }
}
