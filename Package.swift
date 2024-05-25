// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SPTest",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SPTest",
            targets: ["SPTest"]),
        .library(
            name: "SPTestMacros",
            targets: ["SPTestMacros"]
        ),
        .executable(
            name: "SPTestMacrosClient",
            targets: ["SPTestMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SPTest"),
        .testTarget(
            name: "SPTestTests",
            dependencies: ["SPTest"]),
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "SPTestMacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "SPTestMacros", dependencies: ["SPTestMacrosMacros", "SPTest"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "SPTestMacrosClient", dependencies: ["SPTestMacros", "SPTest"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "SPTestMacrosTests",
            dependencies: [
                "SPTestMacrosMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
