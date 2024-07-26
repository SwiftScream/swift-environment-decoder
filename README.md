# Swift Environment Decoder

Type-safe access to your environment leveraging Swift's `Decodable`

[![CI](https://github.com/SwiftScream/swift-environment-decoder/actions/workflows/ci.yml/badge.svg)](https://github.com/SwiftScream/swift-environment-decoder/actions/workflows/ci.yml)
[![Codecov branch](https://img.shields.io/codecov/c/github/SwiftScream/swift-environment-decoder/master.svg)](https://codecov.io/gh/SwiftScream/swift-environment-decoder/branch/master)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftScream%2Fswift-environment-decoder%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SwiftScream/swift-environment-decoder)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSwiftScream%2Fswift-environment-decoder%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SwiftScream/swift-environment-decoder)

[![license](https://img.shields.io/github/license/SwiftScream/swift-environment-decoder.svg)](https://raw.githubusercontent.com/SwiftScream/swift-environment-decoder/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/SwiftScream/swift-environment-decoder.svg)](https://github.com/SwiftScream/swift-environment-decoder/releases/latest)

## Getting Started

### Swift Package Manager
Add `.package(url: "https://github.com/SwiftScream/swift-environment-decoder.git", from: "0.1.0")` to your Package.swift dependencies

## Usage

### Decoding the Environment

```swift
import EnvironmentDecoder

struct MyEnvironmentFeatureFlags: Decodable {
    let enableA: Bool
    let enableB: Bool
}

struct MyEnvironment: Decodable {
    let port: UInt16
    let allowedRegions: [String]
    let featureFlags: MyEnvironmentFeatureFlags
}

let environment = try EnvironmentDecoder().decode(MyEnvironment.self)

print("\(environment.allowedRegions.count) allowed region(s)")
print("listening on port \(environment.port)")
if environment.featureFlags.enableA {
    print("A is enabled")
}
if environment.featureFlags.enableB {
    print("B is enabled")
}
```

The above code expects an environment of the form:

```
PORT=1234
ALLOWED_REGIONS=regionA,regionB,regionC
FEATURE_FLAGS_ENABLE_A=true
FEATURE_FLAGS_ENABLE_B=false
```

#### When Things Go Wrong
If the environment cannot be decoded into the specified type, a `Swift.DecodingError` is thrown.

This is a great way to catch issues with the environment early. In some cases it may be appropriate to output a message, and terminate the process.

Some examples of why this may occur:

 - a required environment variable is not specified
 - the value of an environment variable cannot be decoded as the specified type

```swift
let environment: MyEnvironment
do {
    environment = try EnvironmentDecoder().decode(MyEnvironment.self)
} catch {
    fatalError(error.localizedDescription)
}
```

### Alternative Environment

By default EnvironmentDecoder will decode `ProcessInfo.processInfo.environment`.
If that's not what you want, you can pass in a `[String: String]` instead.

```swift
let someEnvDictionary: [String: String] = //...
let environment = try EnvironmentDecoder().decode(MyEnvironment.self, from: someEnvDictionary)
```
