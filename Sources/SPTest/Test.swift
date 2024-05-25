// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

private enum TestResult {
    case success
    case failed(TestFailure)
    case threw(Error)
}

private struct TestLabel: View {
    var text: LocalizedStringKey
    var icon: String
    var color: Color
    init(_ text: LocalizedStringKey, icon: String, _ color: Color) {
        self.text = text
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        Label {
            Text(text)
                .foregroundStyle(color)
        } icon: {
            Image(systemName: icon)
                .foregroundStyle(color.gradient)
        }
    }
}

public struct Test: View {
    var name: String
    var testBody: () async throws -> ()
    @State var autorun: Bool
    @State private var result: TestResult? = nil
    
    public init(_ name: String, autorun: Bool = true, body testBody: @escaping () async throws -> ()) {
        self.name = name
        self.autorun = autorun
        self.testBody = testBody
    }
    fileprivate init(_ result: TestResult?) {
        self.name = "PreviewTest"
        self.autorun = false
        self.testBody = {}
        self._result = State(initialValue: result)
    }
    
    public var body: some View {
        Section {
            if let result {
                switch result {
                case .success:
                    TestLabel("Succeeded", icon: "checkmark.diamond.fill", .green)
                case .failed(let failure):
                    TestLabel("Failed", icon: "xmark.diamond.fill", .red)
                    Text(failure.description)
                        .foregroundStyle(.gray)
                case .threw(let error):
                    TestLabel("Error thrown", icon: "xmark.diamond.fill", .red)
                    Text(error.localizedDescription)
                        .foregroundStyle(.gray)
                }
            } else if autorun {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Running…")
                    .task {
                        do {
                            try await testBody()
                            result = .success
                        } catch let error as TestFailure {
                            result = .failed(error)
                        } catch {
                            result = .threw(error)
                        }
                    }
            } else {
                Button {
                    autorun = true
                } label: {
                    TestLabel("Run", icon: "diamond.fill", .gray)
                }
            }
        } header: {
            HStack {
                Text("Test \(name)")
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        result = nil
                    }
                } label: {
                    Label {
                        Text("Rerun")
                    } icon: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(result == nil ? 360 : 0))
                    }
                }
            }
        }
    }
}

#Preview("Success") {
    TestPlan {
        Test(.success)
    }
}
#Preview("Failure") {
    TestPlan {
        Test(.failed(TestFailure(description: "Preview")))
    }
}
#Preview("Error") {
    TestPlan {
        Test(.threw(CocoaError(.fileNoSuchFile)))
    }
}
