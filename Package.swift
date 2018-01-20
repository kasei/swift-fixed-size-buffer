// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FixedSizeBuffer",
    products: [
        .library(
            name: "fixed-size-buffer",
            targets: ["fixed-size-buffer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "fixed-size-buffer",
            dependencies: []),
        .testTarget(
            name: "fixed-size-bufferTests",
            dependencies: ["fixed-size-buffer"]),
    ]
)
