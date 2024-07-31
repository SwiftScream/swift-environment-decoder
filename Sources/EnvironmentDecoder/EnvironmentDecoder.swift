import Foundation

/// `EnvironmentDecoder` facilitates the decoding of environment variables into semantic `Decodable` types.
public final class EnvironmentDecoder {
    /// The strategy to use for decoding `Data` values.
    public enum DataDecodingStrategy: Sendable {
        /// Defer to `Data` for decoding.
        case deferredToData

        /// Decode the `Data` from a Base64-encoded string. This is the default strategy.
        case base64
    }

    private let dataDecodingStrategy: DataDecodingStrategy

    /// Initializes `self` with default configuration.
    /// - Parameter dataDecodingStrategy: the strategy to use for decoding Data.
    ///
    /// - Note: dataDecodingStrategy is ignored for Data in an unkeyed container - base64 is always used.
    public init(dataDecodingStrategy: DataDecodingStrategy = .base64) {
        self.dataDecodingStrategy = dataDecodingStrategy
    }

    /// Decodes a top-level value of the given type from the given environment representation.
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - environment: The environment dictionary to decode from, defaults to `ProcessInfo.processInfo.environment`
    /// - Returns: A value of the requested type.
    /// - Throws: `DecodingError` if an error occurs during decoding
    /// - Throws: An error if any value throws an error during decoding
    public func decode<T: Decodable>(_ type: T.Type, from environment: [String: String] = ProcessInfo.processInfo.environment) throws -> T {
        let decoder = EnvironmentDecoderImpl(environment: environment,
                                             codingPathNode: .root,
                                             dataDecodingStrategy: dataDecodingStrategy)
        return try type.init(from: decoder)
    }
}
