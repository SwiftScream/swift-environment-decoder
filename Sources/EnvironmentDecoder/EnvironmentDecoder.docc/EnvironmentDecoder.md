# ``EnvironmentDecoder``


## Overview

Suppose you're building a server app and want to enable specifying the port to bind to in the environment. You might write something like this:

```
let port = Int(ProcessInfo.processInfo.environment["PORT"]) ?? 3000
```

As your use of the environment grows, this can become cumbersome and error prone.

``EnvironmentDecoder`` enables type-safe access to the environment leveraging Swift's `Decodable`.

To use it you specify the shape of the environment that your application expects as a `Decodable` struct. ``EnvironmentDecoder`` can instantiate an instance of this struct from the current environment, throwing an Error if the environment is not valid.

## Example

Let's say you have a server app and want the environment to specify the port to bind to, a list of allowed regions, and a couple of boolean feature flags.

Your environment might look like:

```
PORT=1234
ALLOWED_REGIONS=regionA,regionB,regionC
FEATURE_FLAGS_ENABLE_A=true
FEATURE_FLAGS_ENABLE_B=false
```

``EnvironmentDecoder`` enables access to this like:
 
```swift
import EnvironmentDecoder

struct MyEnvironment: Decodable {
    let port: UInt16
    let allowedRegions: [String]
    let featureFlags: MyEnvironmentFeatureFlags
}

struct MyEnvironmentFeatureFlags: Decodable {
    let enableA: Bool
    let enableB: Bool
}

let environment = try EnvironmentDecoder().decode(MyEnvironment.self)
```

## Mapping Properties to Environment Variables

Environment variables are a flat namespace, but Decodable types can be nested to create meaningful hierarchy.

``EnvironmentDecoder`` will, by default, leverage the type hierarcy to create meaningful environment variable names. This can be disabled in the initializer by specifying `prefixKeysWithCodingPath: false`.

#### An Example:

```swift
struct DatabaseConnection: Decodable {
    let connectionString: String
}

struct WebServiceConnection: Decodable {
    let host: String
    let port: Int16
}

struct Environment: Decodable {
    let region: String
    let database: DatabaseConnection
    let webService: WebServiceConnection
}
```

When `prefixKeysWithCodingPath` is enabled the environment is expected to be:
```
REGION
DATABASE_CONNECTION_STRING
WEB_SERVICE_HOST
WEB_SERVICE_PORT
```

When `prefixKeysWithCodingPath` is disabled the environment is expected to be:
```
REGION
CONNECTION_STRING
HOST
PORT
```

The usual methods that the Codable framework provides can be used to customise coding keys.

## Supported Data Types

Almost all `Decodable` data structures are supported.

The one limitation is that elements of an Unkeyed Container must not be represented by an Unkeyed Container or Keyed Container.
For example, elements of an array cannot themselves be an array, or an object represented by key/value pairs.

It is possible to use a custom Decodable type in an array, so long as that type decodes from a single value.

Outside of this limitation, all Decodable types are supported. Some notes on specific data types follows.

#### Data

Several strategies are supported for decoding `Data`.

Refer to ``EnvironmentDecoder/DataDecodingStrategy``

#### Date

Several strategies are supported for decoding `Date`.

Refer to ``EnvironmentDecoder/DateDecodingStrategy``

#### Unkeyed Containers

UnkeyedContainers, for example Arrays, are supported so long as the element value is represented by a single value.

UnkeyedContainer values are decoded from a character-separated list of values.
By default the separator character is a comma. This can be customised by specifying `unkeyedContainerSeparator` in the initializer.

By default whitespace is trimmed from unkeyed container values. This can be disabled by specifying `trimWhitespaceFromUnkeyedContainerValues` in the initializer. 


## Error Handling

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

## Alternative Environment

By default EnvironmentDecoder will decode `ProcessInfo.processInfo.environment`.
If that's not what you want, you can pass in a `[String: String]` instead.

```swift
let someEnvDictionary: [String: String] = //...
let environment = try EnvironmentDecoder().decode(MyEnvironment.self, from: someEnvDictionary)
```
