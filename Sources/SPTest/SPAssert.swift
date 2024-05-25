import SwiftUI

struct TestFailure: Error {
    var description: String
}

public func SPAssert(_ condition: Bool, description: String = "Assertion failed") throws {
    if !condition {
        throw TestFailure(description: description)
    }
}

public func SPUnwrap<T>(_ value: T?) throws -> T {
    if let value { return value }
    throw TestFailure(description: "Unwrap failed")
}
