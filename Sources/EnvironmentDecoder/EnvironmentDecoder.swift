import Foundation

public final class EnvironmentDecoder {
    public init() {}

    public func decode<T: Decodable>(_ type: T.Type, from environment: [String: String] = ProcessInfo.processInfo.environment) throws -> T {
        let decoder = EnvironmentDecoderImpl(environment: environment, codingPathNode: .root)
        return try type.init(from: decoder)
    }
}
