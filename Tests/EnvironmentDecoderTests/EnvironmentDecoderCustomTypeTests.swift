import Foundation
import Testing

struct EnvironmentDecoderCustomTypeTests {
    @Test func urlTest() throws {
        #expect(try decode("https://example.com", as: URL.self).absoluteString == "https://example.com")
        #expect(try decode("example.com", as: URL.self).absoluteString == "example.com")
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: URL.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: URL.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" https://example.com", as: URL.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("https://example.com ", as: URL.self)
        }
    }
}
