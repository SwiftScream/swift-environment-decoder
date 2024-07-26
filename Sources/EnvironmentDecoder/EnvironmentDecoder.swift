import Foundation

/// `EnvironmentDecoder` facilitates the decoding of environment variables into semantic `Decodable` types.
public final class EnvironmentDecoder {
    /// Initializes `self` with default configuration.
    public init() {}

    /// Decodes a top-level value of the given type from the given environment representation.
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - environment: The environment dictionary to decode from, defaults to `ProcessInfo.processInfo.environment`
    /// - Returns: A value of the requested type.
    /// - Throws: `DecodingError` if an error occurs during decoding
    /// - Throws: An error if any value throws an error during decoding
    public func decode<T: Decodable>(_ type: T.Type, from environment: [String: String] = ProcessInfo.processInfo.environment) throws -> T {
        let decoder = EnvironmentDecoderImpl(environment: environment, codingPathNode: .root)
        return try type.init(from: decoder)
    }
}
