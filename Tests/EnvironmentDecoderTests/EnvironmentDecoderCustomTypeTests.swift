import EnvironmentDecoder
import Foundation
import Testing

struct EnvironmentDecoderCustomTypeTests {
    @Test func base64DataTest() throws {
        #expect(try decode("", as: Data.self) == Data())
        #expect(try decode("AQIDBAUGBwg=", as: Data.self) == Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wZWQgb3ZlciB0aGUgbGF6eSBkb2ch", as: Data.self)
            == Data("The quick brown fox jumped over the lazy dog!".utf8))
        #expect(try decode("VGhl,cXVpY2s=,YnJvd24=,Zm94", as: [Data].self)
            == ["The", "quick", "brown", "fox"].map { Data($0.utf8) })
        #expect(throws: Swift.DecodingError.self) {
            try decode(" ", as: Data.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("invalid-base-64", as: Data.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Data.self)
        }
    }

    @Test func delegatedDataTest() throws {
        let decoder = EnvironmentDecoder(dataDecodingStrategy: .deferredToData)
        #expect(try decode("", as: Data.self, with: decoder) == Data())
        #expect(try decode("1,2,3,4,5,6,7,8", as: Data.self, with: decoder) == Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8", as: Data.self, with: decoder) == Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08", as: Data.self, with: decoder) == Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("0x54,0x68,0x65,0x20,0x71,0x75,0x69,0x63,0x6b,0x20,0x62,0x72,0x6f,0x77,0x6e,0x20,0x66,0x6f,0x78,0x20,0x6a,0x75,0x6d,0x70,0x65,0x64,0x20,0x6f,0x76,0x65,0x72,0x20,0x74,0x68,0x65,0x20,0x6c,0x61,0x7a,0x79,0x20,0x64,0x6f,0x67,0x21", as: Data.self, with: decoder)
            == Data("The quick brown fox jumped over the lazy dog!".utf8))
        #expect(try decode("VGhl,cXVpY2s=,YnJvd24=,Zm94", as: [Data].self)
            == ["The", "quick", "brown", "fox"].map { Data($0.utf8) })
        #expect(throws: Swift.DecodingError.self) {
            try decode(" ", as: Data.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("invalid,int,array", as: Data.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Data.self)
        }
    }

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
