// The Swift Programming Language
// https://docs.swift.org/swift-book

import SPTest
import SwiftUI

///
@freestanding(expression)
public macro assert(_ condition: Bool) -> () = #externalMacro(module: "SPTestMacrosMacros", type: "SPAssertMacro")

@freestanding(expression)
public macro unwrap<T>(_ value: T?) -> T = #externalMacro(module: "SPTestMacrosMacros", type: "SPUnwrapMacro")

@freestanding(expression)
public macro TestPlan<Tests: View>(_ title: String? = nil, @ViewBuilder body: @MainActor () -> Tests) -> () = #externalMacro(module: "SPTestMacrosMacros", type: "SPTestPlanMacro")
