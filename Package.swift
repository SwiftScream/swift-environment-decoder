// swift-tools-version: 6.0

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
            name: "EnvironmentDecoder",
            resources: [.process("PrivacyInfo.xcprivacy")]),
        .testTarget(
            name: "EnvironmentDecoderTests",
            dependencies: ["EnvironmentDecoder"]),
    ])
