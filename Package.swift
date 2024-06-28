// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-environment-decoder",
    products: [
        .library(
            name: "EnvironmentDecoder",
            targets: ["EnvironmentDecoder"]),
    ],
    targets: [
        .target(
            name: "EnvironmentDecoder"),
        .testTarget(
            name: "EnvironmentDecoderTests",
            dependencies: ["EnvironmentDecoder"]),
    ])
