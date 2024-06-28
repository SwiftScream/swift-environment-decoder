import Foundation

public final class EnvironmentDecoder {
    public init() {}

    public func decode<T: Decodable>(_ type: T.Type, from environment: [String: String] = ProcessInfo.processInfo.environment) throws -> T {
        let decoder = EnvironmentDecoderImpl(environment: environment, codingPathNode: .root)
        return try type.init(from: decoder)
    }
}

private class EnvironmentDecoderImpl {
    let environment: [String: String]
    var valueOverride: String? // used for SingleValueContainer decoding what must be a single string
    var userInfo: [CodingUserInfoKey: Any] = [:]

    var codingPathNode: CodingPathNode

    init(environment: [String: String], codingPathNode: CodingPathNode) {
        self.codingPathNode = codingPathNode
        self.environment = environment
    }
}

extension EnvironmentDecoderImpl {
    // Instead of creating a new EnvironmentDecoderImpl for passing to methods that take Decoder arguments,
    // wrap the access in this method, which temporarily mutates this instance with its coding path.
    func with<T>(path: CodingPathNode?, perform closure: () throws -> T) rethrows -> T {
        let oldPath = codingPathNode
        if let path {
            codingPathNode = path
        }

        defer {
            if path != nil {
                self.codingPathNode = oldPath
            }
        }

        return try closure()
    }

    func with<T>(singleValue: String, perform closure: () throws -> T) rethrows -> T {
        let oldValue = valueOverride
        valueOverride = singleValue

        defer {
            self.valueOverride = oldValue
        }

        return try closure()
    }

    func unwrap<T: Decodable>(_ type: T.Type, for codingPathNode: CodingPathNode) throws -> T {
        try with(path: codingPathNode) {
            try type.init(from: self)
        }
    }

    func unwrap<T: Decodable>(singleValue: String, as type: T.Type) throws -> T {
        try with(singleValue: singleValue) {
            try type.init(from: self)
        }
    }

    private func unwrapBool(for codingPath: [CodingKey]) throws -> Bool {
        let value = try getValue(for: codingPath)
        return try EnvironmentDecoderImpl.unwrapBool(from: value, for: codingPath)
    }

    private static func unwrapBool(from value: String, for codingPath: [CodingKey]) throws -> Bool {
        guard let result = Bool(value) else {
            throw DecodingError.typeMismatch(Bool.self, .init(
                codingPath: codingPath,
                debugDescription: "Failed to parse as \(Bool.self)."))
        }
        return result
    }

    private func unwrapString(for codingPath: [CodingKey]) throws -> String {
        try getValue(for: codingPath)
    }

    private func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        as _: T.Type,
        for codingPath: [CodingKey]) throws -> T {
        let value = try getValue(for: codingPath)
        return try EnvironmentDecoderImpl.unwrapFixedWidthInteger(from: value, as: T.self, for: codingPath)
    }

    private static func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        from value: String,
        as type: T.Type,
        for codingPath: [CodingKey]) throws -> T {
        guard let result = T(value) else {
            throw DecodingError.typeMismatch(type, .init(
                codingPath: codingPath,
                debugDescription: "Failed to parse as \(type)."))
        }
        return result
    }

    private func unwrapFloat(for codingPath: [CodingKey]) throws -> Float {
        let value = try getValue(for: codingPath)
        return try EnvironmentDecoderImpl.unwrapFloat(from: value, for: codingPath)
    }

    private static func unwrapFloat(
        from value: String,
        for codingPath: [CodingKey]) throws -> Float {
        guard let result = Float(value) else {
            throw DecodingError.typeMismatch(Float.self, .init(
                codingPath: codingPath,
                debugDescription: "Failed to parse as \(Float.self)."))
        }
        return result
    }

    private func unwrapDouble(for codingPath: [CodingKey]) throws -> Double {
        let value = try getValue(for: codingPath)
        return try EnvironmentDecoderImpl.unwrapDouble(from: value, for: codingPath)
    }

    private static func unwrapDouble(
        from value: String,
        for codingPath: [CodingKey]) throws -> Double {
        guard let result = Double(value) else {
            throw DecodingError.typeMismatch(Double.self, .init(
                codingPath: codingPath,
                debugDescription: "Failed to parse as \(Double.self)."))
        }
        return result
    }

    private func getValue() throws -> String {
        try getValue(for: codingPath)
    }

    private func getValue(for codingPath: [CodingKey]) throws -> String {
        if let valueOverride {
            return valueOverride
        }
        let environmentVariableName = EnvironmentDecoderImpl.environmentVariableName(for: codingPath)
        guard let value = environment[environmentVariableName] else {
            let key = codingPath.last ?? GenericCodingKey(stringValue: "")
            throw DecodingError.keyNotFound(key, .init(
                codingPath: codingPath,
                debugDescription: "No value associated with key \(key) (\"\(environmentVariableName)\")."))
        }
        return value
    }

    private static func environmentVariableName(for codingPath: [CodingKey]) -> String {
        codingPath.map {
            convertToUppercaseSnakeCase($0.stringValue)
        }.joined(separator: "_")
    }
}

extension EnvironmentDecoderImpl: Decoder {
    var codingPath: [CodingKey] {
        codingPathNode.path
    }

    func container<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        let container = KeyedContainer<Key>(
            impl: self,
            codingPathNode: codingPathNode)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let value = try getValue()
        return UnkeyedContainer(
            impl: self,
            codingPathNode: codingPathNode,
            string: value)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        self
    }
}

extension EnvironmentDecoderImpl: SingleValueDecodingContainer {
    private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        try EnvironmentDecoderImpl.unwrapFixedWidthInteger(from: getValue(), as: T.self, for: codingPath)
    }

    func decodeNil() -> Bool {
        false
    }

    func decode(_: Bool.Type) throws -> Bool {
        try EnvironmentDecoderImpl.unwrapBool(from: getValue(), for: codingPath)
    }

    func decode(_: String.Type) throws -> String {
        try getValue()
    }

    func decode(_: Double.Type) throws -> Double {
        try EnvironmentDecoderImpl.unwrapDouble(from: getValue(), for: codingPath)
    }

    func decode(_: Float.Type) throws -> Float {
        try EnvironmentDecoderImpl.unwrapFloat(from: getValue(), for: codingPath)
    }

    func decode(_: Int.Type) throws -> Int {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int8.Type) throws -> Int8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int16.Type) throws -> Int16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int32.Type) throws -> Int32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int64.Type) throws -> Int64 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt.Type) throws -> UInt {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        try decodeFixedWidthInteger()
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try unwrap(singleValue: getValue(), as: type)
    }
}

extension EnvironmentDecoderImpl {
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let impl: EnvironmentDecoderImpl
        let codingPathNode: CodingPathNode

        public var codingPath: [CodingKey] {
            codingPathNode.path
        }

        var allKeys: [Key] {
            let prefix = environmentVariablePrefix()
            let prefixCount = prefix.count

            return impl.environment.keys.compactMap {
                guard $0.hasPrefix(prefix) else {
                    return nil
                }
                return Key(stringValue: String($0.dropFirst(prefixCount)))
            }
        }

        func contains(_ key: Key) -> Bool {
            let environmentVariableName = environmentVariableName(forKey: key)
            let environmentVariablePrefix = environmentVariableName + "_"
            return impl.environment.contains { candidate, _ in
                candidate == environmentVariableName || candidate.hasPrefix(environmentVariablePrefix)
            }
        }

        func decodeNil(forKey _: Key) throws -> Bool {
            false
        }

        func decode(_: Bool.Type, forKey key: Key) throws -> Bool {
            try impl.unwrapBool(for: codingPathNode.path(byAppending: key))
        }

        func decode(_: String.Type, forKey key: Key) throws -> String {
            try impl.unwrapString(for: codingPathNode.path(byAppending: key))
        }

        func decode(_: Double.Type, forKey key: Key) throws -> Double {
            try impl.unwrapDouble(for: codingPathNode.path(byAppending: key))
        }

        func decode(_: Float.Type, forKey key: Key) throws -> Float {
            try impl.unwrapFloat(for: codingPathNode.path(byAppending: key))
        }

        func decode(_: Int.Type, forKey key: Key) throws -> Int {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int8.Type, forKey key: Key) throws -> Int8 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int16.Type, forKey key: Key) throws -> Int16 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int32.Type, forKey key: Key) throws -> Int32 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int64.Type, forKey key: Key) throws -> Int64 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt.Type, forKey key: Key) throws -> UInt {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt8.Type, forKey key: Key) throws -> UInt8 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt16.Type, forKey key: Key) throws -> UInt16 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt32.Type, forKey key: Key) throws -> UInt32 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt64.Type, forKey key: Key) throws -> UInt64 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
            try impl.unwrap(type, for: codingPathNode.appending(key))
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
            try impl.with(path: codingPathNode.appending(key)) {
                try impl.container(keyedBy: type)
            }
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
            try impl.with(path: codingPathNode.appending(key)) {
                try impl.unkeyedContainer()
            }
        }

        func superDecoder() throws -> any Decoder {
            decoderForKey(GenericCodingKey.super)
        }

        func superDecoder(forKey key: Key) throws -> any Decoder {
            decoderForKey(key)
        }

        private func decoderForKey(_ key: some CodingKey) -> EnvironmentDecoderImpl {
            EnvironmentDecoderImpl(environment: impl.environment, codingPathNode: codingPathNode.appending(key))
        }

        private func environmentVariablePrefix() -> String {
            EnvironmentDecoderImpl.environmentVariableName(for: codingPath).appending("_")
        }

        private func environmentVariableName(forKey key: some CodingKey) -> String {
            EnvironmentDecoderImpl.environmentVariableName(for: codingPathNode.path(byAppending: key))
        }

        private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Key) throws -> T {
            try impl.unwrapFixedWidthInteger(as: T.self, for: codingPathNode.path(byAppending: key))
        }
    }
}

extension EnvironmentDecoderImpl {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let impl: EnvironmentDecoderImpl
        let codingPathNode: CodingPathNode
        let values: [String]
        private(set) var currentIndex: Int

        init(impl: EnvironmentDecoderImpl, codingPathNode: CodingPathNode, string: String) {
            self.impl = impl
            self.codingPathNode = codingPathNode
            values = string.components(separatedBy: ",")
            currentIndex = values.startIndex
        }

        public var codingPath: [CodingKey] {
            codingPathNode.path
        }

        var count: Int? {
            values.count
        }

        var isAtEnd: Bool {
            currentIndex >= values.endIndex
        }

        mutating func decodeNil() throws -> Bool {
            false
        }

        mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            let value = try impl.unwrap(singleValue: values[currentIndex], as: type)
            currentIndex += 1
            return value
        }

        mutating func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
            throw DecodingError.typeMismatch(KeyedDecodingContainer<NestedKey>.self, .init(
                codingPath: codingPathNode.path(byAppending: GenericCodingKey(intValue: currentIndex)),
                debugDescription: "No nested keyed container found"))
        }

        mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
            throw DecodingError.typeMismatch(UnkeyedDecodingContainer.self, .init(
                codingPath: codingPathNode.path(byAppending: GenericCodingKey(intValue: currentIndex)),
                debugDescription: "No nested unkeyed container found"))
        }

        mutating func superDecoder() throws -> any Decoder {
            throw DecodingError.typeMismatch(EnvironmentDecoderImpl.self, .init(
                codingPath: codingPathNode.path(byAppending: GenericCodingKey(intValue: currentIndex)),
                debugDescription: "No super decoder found"))
        }
    }
}
