// The Swift Programming Language
// https://docs.swift.org/swift-book

import SPTest
import SwiftUI

///
@freestanding(expression)
public macro SPAssert(_ condition: Bool) -> () = #externalMacro(module: "SPTestMacrosMacros", type: "SPAssertMacro")

@freestanding(expression)
public macro SPUnwrap<T>(_ value: T?) -> T = #externalMacro(module: "SPTestMacrosMacros", type: "SPUnwrapMacro")

// #TestPlan - Doesn't trigger previews

//@freestanding(expression)
//public macro TestPlan<Tests: View>(_ title: String? = nil, @ViewBuilder body: @MainActor () -> Tests) -> () = #externalMacro(module: "SPTestMacrosMacros", type: "SPTestPlanMacro")












#Preview("TestPlan") {
    TestPlan {
        Test("Success") {
            try #SPAssert(true)
        }
        Test("No macros") {
            try SPAssert(false, description: "Always false")
        }
        Test("Failure") {
            let val = true
            try #SPAssert(val == false)
        }
        Test("Unwrap Failure") {
            let opt = Int?.none
            _ = try #SPUnwrap(opt)
        }
        Test("Error") {
            throw CocoaError(.fileNoSuchFile)
        }
    }
}
