// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-environment-decoder",
    products: [
        .library(
            name: "EnvironmentDecoder",
            targets: ["EnvironmentDecoder"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "EnvironmentDecoder"),
    ])
