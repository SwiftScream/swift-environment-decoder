import Foundation
import Testing

struct EnvironmentDecoderCustomTypeTests {
    @Test func decimalTest() throws {
        let formatter = Decimal.FormatStyle(locale: .init(identifier: ""))
            .precision(.integerAndFractionLength(integerLimits: 1...10, fractionLimits: 0...10))

        #expect(try decode("0", as: Decimal.self).formatted(formatter) == "0")
        #expect(try decode("+0", as: Decimal.self).formatted(formatter) == "0")
        #expect(try decode("-0", as: Decimal.self).formatted(formatter) == "0")
        #expect(try decode("3.1415926", as: Decimal.self).formatted(formatter) == "3.1415926")
        #expect(try decode("+3.1415926", as: Decimal.self).formatted(formatter) == "3.1415926")
        #expect(try decode("-3.1415926", as: Decimal.self).formatted(formatter) == "-3.1415926")
        #expect(try decode("3", as: Decimal.self).formatted(formatter) == "3")
        #expect(try decode("+3", as: Decimal.self).formatted(formatter) == "3")
        #expect(try decode("-3", as: Decimal.self).formatted(formatter) == "-3")
        #expect(try decode("2837.5e-2", as: Decimal.self).formatted(formatter) == "28.375")
        #expect(try decode("-2837.5e-2", as: Decimal.self).formatted(formatter) == "-28.375")
        #expect(try decode(" 5.0", as: Decimal.self).formatted(formatter) == "5")
        #expect(try decode("42degrees", as: Decimal.self).formatted(formatter) == "42")
        #expect(try decode(" 1.23", as: Decimal.self).formatted(formatter) == "1.23")
        #expect(try decode("1.23 ", as: Decimal.self).formatted(formatter) == "1.23")
        #expect(try decode("3,3.14,-3", as: [Decimal].self).map { $0.formatted(formatter) } == ["3", "3.14", "-3"])
        #expect(throws: Swift.DecodingError.self) {
            try decode("inf", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("infinity", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("nan", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1.23e17802", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-1.23e17802", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("±2.0", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Decimal.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Decimal.self)
        }
    }

    @Test func urlTest() throws {
        #expect(try decode("https://example.com", as: URL.self).absoluteString == "https://example.com")
        #expect(try decode("example.com", as: URL.self).absoluteString == "example.com")
        #expect(try decode("a.example.com,b.example.com", as: [URL].self).map(\.absoluteString) == ["a.example.com", "b.example.com"])
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
