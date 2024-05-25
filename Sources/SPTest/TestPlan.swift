import SwiftUI

public struct TestPlan<Tests: View>: View {
    @ViewBuilder var tests: () -> Tests
    
    public init(@ViewBuilder tests: @escaping () -> Tests) {
        self.tests = tests
    }
    
    public var body: some View {
        List {
            tests()
        }.headerProminence(.increased)
    }
}

#if DEBUG
private func myTask(_ input: Int) async throws -> String {
    String(input)
}

#Preview("TestPlan") {
    TestPlan {
        Test("TestExample") {
            let input = 1
            let result = try await myTask(input)
            print(result)
            try SPAssert(result == "1", description: "result == 1")
            
            _ = try SPUnwrap(Int?.some(2))
        }
    }
}
#endif
