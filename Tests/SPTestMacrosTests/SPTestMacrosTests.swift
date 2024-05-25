import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SPTestMacrosMacros)
import SPTestMacrosMacros

let testMacros: [String: Macro.Type] = [
    "SPAssert": SPAssertMacro.self,
]
#endif

final class SPTestMacrosTests: XCTestCase {
    func testMacro() throws {
        #if canImport(SPTestMacrosMacros)
        assertMacroExpansion(
            """
            #SPAssert(a + b)
            """,
            expandedSource: """
            SPAssert(a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(SPTestMacrosMacros)
        assertMacroExpansion(
            #"""
            #SPAssert("Hello, \(name)")
            """#,
            expandedSource: #"""
            SPAssert("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
