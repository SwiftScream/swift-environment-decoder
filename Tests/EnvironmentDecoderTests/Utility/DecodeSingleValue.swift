@testable import EnvironmentDecoder
import Foundation
import Testing

private struct TestDecodable<T: Decodable>: Decodable {
    let value: T
}

func decode<T: Decodable>(_ value: String?, as _: T.Type, with environmentDecoder: EnvironmentDecoder = EnvironmentDecoder()) throws -> T {
    let environment: [String: String] = if let value {
        ["VALUE": value]
    } else {
        [:]
    }
    return try environmentDecoder.decode(TestDecodable<T>.self, from: environment).value
}
