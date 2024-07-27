@testable import EnvironmentDecoder
import Foundation
import Testing

private struct TestDecodable<T: Decodable>: Decodable {
    let value: T
}

func decode<T: Decodable>(_ value: String?, as _: T.Type) throws -> T {
    let environment: [String: String] = if let value {
        ["VALUE": value]
    } else {
        [:]
    }
    return try EnvironmentDecoder().decode(TestDecodable<T>.self, from: environment).value
}
