// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FixedSizeBuffer",
    products: [
        .library(
            name: "FixedSizeBuffer",
            targets: ["FixedSizeBuffer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FixedSizeBuffer",
            dependencies: []),
        .testTarget(
            name: "FixedSizeBufferTests",
            dependencies: ["FixedSizeBuffer"]),
    ]
)
