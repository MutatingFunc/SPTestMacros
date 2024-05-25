import SPTestMacros
import SPTest
import SwiftUI

let a = 17
let b = 25

try #SPAssert(a + b == 42)

#TestPlan("Example") {
    Test("Test") {
        print("Running")
        try #SPAssert(true)
        let i = try #SPUnwrap(2)
    }
}
