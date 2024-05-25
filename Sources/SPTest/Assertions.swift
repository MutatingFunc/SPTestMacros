import SwiftUI

struct TestFailure: Error {
    var description: String
}

public func SPAssert(_ condition: Bool, description: String? = nil) throws {
    if !condition {
        throw TestFailure(
            description: [
                "SPAssert",
                description
            ].compactMap { $0 }.joined(separator: " ← ")
        )
    }
}

public func SPUnwrap<T>(_ value: T?, description: String? = nil) throws -> T {
    if let value { return value }
    throw TestFailure(
        description: [
            "SPUnwrap",
            description
        ].compactMap { $0 }.joined(separator: " ← ")
    )
}
