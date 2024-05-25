import SPTestMacros
import SPTest
import SwiftUI

let a = 17
let b = 25

#assert(a + b == 42)

#TestPlan("Example") {
    Test("Test") {
        print("Running")
    }
}
