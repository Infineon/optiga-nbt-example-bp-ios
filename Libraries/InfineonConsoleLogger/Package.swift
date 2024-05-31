// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import PackageDescription

let packageName = "InfineonConsoleLogger"
let packageVersion = "0.1.0"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to
        // other packages.
        .library(
            name: packageName,
            targets: ["InfineonConsoleLogger"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.

        .package(path: "../optiga-nbt-lib-swift/Sources/hsw-logger-swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "InfineonConsoleLogger",
            dependencies: [.product(name: "InfineonLogger", package: "hsw-logger-swift")]
        ),
        .testTarget(
            name: "InfineonConsoleLoggerTests",
            dependencies: ["InfineonConsoleLogger"]
        )
    ]
)
