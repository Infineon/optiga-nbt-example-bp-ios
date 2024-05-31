// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT
import PackageDescription

let package = Package(
    name: "InfineonChanneliOSNfc",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible
        // to other packages.
        .library(
            name: "InfineonChanneliOSNfc",
            targets: ["InfineonChanneliOSNfc"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../optiga-nbt-lib-swift/Sources/hsw-channel-swift"),
        .package(path: "../optiga-nbt-lib-swift/Sources/hsw-utils-swift"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a
        // test suite.
        // Targets can depend on other targets in this package, and on products in packages this
        // package depends on.
        .target(
            name: "InfineonChanneliOSNfc",
            dependencies: [
                .product(name: "InfineonChannel", package: "hsw-channel-swift"),
                .product(name: "InfineonUtils", package: "hsw-utils-swift"),
            ]
        ),
        .testTarget(
            name: "InfineonChanneliOSNfcTests",
            dependencies: ["InfineonChanneliOSNfc"]
        ),
    ]
)
